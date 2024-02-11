#!/bin/sh

# ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
# ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

# Sign a file
code_sign_file() {
	/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements --timestamp=none "$1"
}

# Strip and code sign framework
strip_and_code_sign_framework() {
	SRC_FRAMEWORK_PATH=$1
	FRAMEWORK_PATH=$2

	FRAMEWORKS_PATH=$(dirname "$FRAMEWORK_PATH")
	EXECUTABLE_NAME=$(/usr/libexec/PlistBuddy -c "print :CFBundleExecutable" "$SRC_FRAMEWORK_PATH/Info.plist")
	EXECUTABLE_PATH="$FRAMEWORK_PATH/$EXECUTABLE_NAME"

	if ! [ -d "$FRAMEWORK_PATH" ]; then
		mkdir -p "$FRAMEWORKS_PATH"
		cp -R "$SRC_FRAMEWORK_PATH" "$FRAMEWORK_PATH"
	else
		SRC_VERSION=$(/usr/libexec/PlistBuddy -c "print :CFBundleVersion" "$SRC_FRAMEWORK_PATH/Info.plist")
		DEST_VERSION=$(/usr/libexec/PlistBuddy -c "print :CFBundleVersion" "$FRAMEWORK_PATH/Info.plist")

		if [ "$SRC_VERSION" != "$DEST_VERSION" ]; then
			rm -rf "$FRAMEWORK_PATH"
			cp -R "$SRC_FRAMEWORK_PATH" "$FRAMEWORK_PATH"
		fi
	fi

	CURRENT_ARCHS="$(lipo -archs "$EXECUTABLE_PATH")"

	EXTRACTED_ARCHS=()
	# to add
	for ARCH in $ARCHS; do
		if ! [[ "${CURRENT_ARCHS}" == *"$ARCH"* ]]; then
			lipo -extract "$ARCH" "$SRC_FRAMEWORK_PATH/$EXECUTABLE_NAME" -o "$EXECUTABLE_PATH-$ARCH"
			rc=$?
			if ! [[ $rc == 0 ]]; then
				cp "$SRC_FRAMEWORK_PATH/$EXECUTABLE_NAME" "$EXECUTABLE_PATH-$ARCH"
			fi
			EXTRACTED_ARCHS+=("$EXECUTABLE_PATH-$ARCH")
		fi
	done

	# to remove
	to_add_executable=0
	for ARCH in $CURRENT_ARCHS; do
		if ! [[ "${ARCHS}" == *"$ARCH"* ]]; then
			lipo -remove "$ARCH" "$EXECUTABLE_PATH" -o "$EXECUTABLE_PATH"
			rc=$?
			if [[ $rc == 0 ]]; then
				to_add_executable=1
			fi
		fi
	done

	if [[ $to_add_executable == 1 ]]; then
		EXTRACTED_ARCHS+=("$EXECUTABLE_PATH")
	fi

	if [[ "$EXTRACTED_ARCHS" ]]; then
		lipo -create "${EXTRACTED_ARCHS[@]}" -o "$EXECUTABLE_PATH-merged"
		rc=$?
		if ! [[ $rc == 0 ]]; then
			exit $rc
		fi

		rm "${EXTRACTED_ARCHS[@]}"

		mv "$EXECUTABLE_PATH-merged" "$EXECUTABLE_PATH"
	fi

	if [[ "${CODE_SIGNING_REQUIRED}" == "YES" ]]; then
		if [[ "$EXTRACTED_ARCHS" ]] || ! [ -d "$FRAMEWORK_PATH/_CodeSignature" ]; then
			echo "$SRC_FRAMEWORK_PATH" " -> " "$FRAMEWORK_PATH"
			code_sign_file "$FRAMEWORK_PATH"
		fi
	fi
}

APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"
if [[ "$ABBYY_RTR_SDK_DISTRIBUTION_ROOT" ]]; then
	LIBS_PATH=$(cd "${ABBYY_RTR_SDK_DISTRIBUTION_ROOT}/libs"; pwd)
else
	LIBS_PATH=$(cd "$(dirname "$0")"; pwd)
fi

find "$LIBS_PATH" -name '*.framework' -type d | while read -r FRAMEWORK_PATH; do
	NAME="$(basename "$FRAMEWORK_PATH")"
	DESTINATION="$APP_PATH/Frameworks/$NAME"
	strip_and_code_sign_framework "$FRAMEWORK_PATH" "$DESTINATION"
done
