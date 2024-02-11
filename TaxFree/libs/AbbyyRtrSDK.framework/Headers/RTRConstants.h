/// ABBYY Mobile Capture © 2020 ABBYY Development, Inc.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <Foundation/Foundation.h>
#import "RTRDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Mobile Capture constants

/// Result stability status: the estimate of how stable the result is,
/// and whether it is likely to be improved by adding new frames.
typedef NS_ENUM(NSInteger, RTRResultStabilityStatus) {
	/// No content available.
	RTRResultStabilityNotReady,
	/// Tentative Content Detected.
	RTRResultStabilityTentative,
	/// Content Verified (matching content found in at least two frames).
	RTRResultStabilityVerified,
	/// Result Available (matching content found in three or more frames,
	/// the result varies with the addition of new frames).
	RTRResultStabilityAvailable,
	/// Result Tentatively Stable (the result has been stable in the last two frames).
	RTRResultStabilityTentativelyStable,
	/// Result Stable (the result has been stable in the last three or more frames).
	RTRResultStabilityStable,
};

/// Codes of warnings returned through callback.
typedef NS_ENUM(NSInteger, RTRCallbackWarningCode) {
	/// No warning.
	RTRCallbackWarningNoWarning,
	/// The image is being recognized too slowly, perhaps something is going wrong.
	RTRCallbackWarningRecognitionIsSlow,
	/// The image probably has low quality.
	RTRCallbackWarningProbablyLowQualityImage,
	/// The chosen recognition language is probably wrong.
	RTRCallbackWarningProbablyWrongLanguage,
	/// The chosen recognition language is wrong.
	RTRCallbackWarningWrongLanguage,
	/// The text is too small. Zoom in or move camera closer.
	RTRCallbackWarningTextTooSmall,
};

/**
 * The type of the text.
 */
typedef NSString* const RTRTextType NS_EXTENSIBLE_STRING_ENUM;

/** Normal */
RTR_API_LINKAGE RTRTextType RTRTextTypeNormal;
/** Matrix */
RTR_API_LINKAGE RTRTextType RTRTextTypeMatrix;
/** OCR_A */
RTR_API_LINKAGE RTRTextType RTRTextTypeOCR_A;
/** OCR_B */
RTR_API_LINKAGE RTRTextType RTRTextTypeOCR_B;
/** MICR_E13B */
RTR_API_LINKAGE RTRTextType RTRTextTypeMICR_E13B;
/** MICR_CMC7 */
RTR_API_LINKAGE RTRTextType RTRTextTypeMICR_CMC7;
/** Receipt */
RTR_API_LINKAGE RTRTextType RTRTextTypeReceipt;

/**
 * The language of the text.
 */
typedef NSString* const RTRLanguageName NS_EXTENSIBLE_STRING_ENUM;

/** Afrikaans */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameAfrikaans;
/** Albanian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameAlbanian;
/** Arabic */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameArabic;
/** Armenian (Eastern) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameArmenianEastern;
/** Armenian (Western) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameArmenianWestern;
/** Azerbaijanian (Cyrillic) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameAzerbaijanianCyrillic;
/** Azerbaijanian (Latin) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameAzerbaijanianLatin;
/** Bashkir */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameBashkir;
/** Basque */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameBasque;
/** Belarusian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameBelarusian;
/** Breton */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameBreton;
/** Bulgarian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameBulgarian;
/** Catalan */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameCatalan;
/** Chechen */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameChechen;
/** Chinese (Simplified) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameChineseSimplified;
/** Chinese (Traditional) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameChineseTraditional;
/** Crimean Tatar */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameCrimeanTatar;
/** Croatian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameCroatian;
/** Czech */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameCzech;
/** Danish */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameDanish;
/** Dutch (Netherlands) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameDutch;
/** Dutch (Belgium) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameDutchBelgian;
/** English */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameEnglish;
/** Estonian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameEstonian;
/** Fijian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameFijian;
/** Finnish */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameFinnish;
/** French */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameFrench;
/** German (Old Spelling) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameGerman;
/** German (New Spelling) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameGermanNewSpelling;
/** Greek */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameGreek;
/** Hawaiian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameHawaiian;
/** Hebrew */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameHebrew;
/** Hungarian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameHungarian;
/** Icelandic */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameIcelandic;
/** Indonesian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameIndonesian;
/** Irish */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameIrish;
/** Italian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameItalian;
/** Japanese */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameJapanese;
/** Kabardian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameKabardian;
/** Kazakh */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameKazakh;
/** Kyrgyz */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameKyrgyz;
/** Korean */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameKorean;
/** Korean (Hangul) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameKoreanHangul;
/** Latin */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameLatin;
/** Latvian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameLatvian;
/** Lithuanian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameLithuanian;
/** Norwegian (Bokmal) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameNorwegianBokmal;
/** Norwegian (Nynorsk) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameNorwegianNynorsk;
/** Macedonian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameMacedonian;
/** Malay */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameMalay;
/** Maori */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameMaori;
/** Moldavian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameMoldavian;
/** Mongol */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameMongol;
/** Ossetic */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameOssetic;
/** Polish */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNamePolish;
/** Portuguese */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNamePortuguese;
/** Portuguese (Brazil) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNamePortugueseBrazilian;
/** Provencal */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameProvencal;
/** Rhaeto-Romanic */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameRhaetoRomanic;
/** Romanian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameRomanian;
/** Russian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameRussian;
/** Samoan */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameSamoan;
/** Serbian (Cyrillic) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameSerbian;
/** Serbian (Latin) */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameSerbianLatin;
/** Slovak */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameSlovak;
/** Slovenian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameSlovenian;
/** Spanish */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameSpanish;
/** Swahili */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameSwahili;
/** Swedish */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameSwedish;
/** Tagalog */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameTagalog;
/** Tatar */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameTatar;
/** Thai */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameThai;
/** Turkish */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameTurkish;
/** Ukrainian */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameUkrainian;
/** Vietnamese */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameVietnamese;
/** Welsh */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameWelsh;
/** Yiddish */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameYiddish;
/** Zulu */
RTR_API_LINKAGE RTRLanguageName RTRLanguageNameZulu;

NS_ASSUME_NONNULL_END
