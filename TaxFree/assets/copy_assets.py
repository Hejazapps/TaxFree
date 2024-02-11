# -*- coding: utf-8 -*-

# ABBYY Mobile Capture © 2020 ABBYY Development, Inc.
# ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

import os
from os.path import join, split

assets_folders_key = 'assets_folders'
valid_asset_subfolders_key = 'valid_asset_subfolders'
predicate_key = 'predicate'

def copy_file_lazy(src, dest):
	import shutil

	if os.access(dest, os.R_OK):
		src_size = os.path.getsize(src)
		dest_size = os.path.getsize(dest)
		if src_size == dest_size:
			return

	try:
		dirPath = os.path.dirname(os.path.abspath(dest))
		os.makedirs(dirPath)
	except OSError as error:
		pass

	print('{} -> {}'.format(src, dest))
	shutil.copyfile(src, dest)

def copy_assets(copy_settings):
	application_path = join(os.environ['TARGET_BUILD_DIR'], os.environ['WRAPPER_NAME'])

	for settings in copy_settings:
		assets_folders = settings[assets_folders_key]
		valid_asset_subfolders = settings[valid_asset_subfolders_key]
		predicate = settings[predicate_key]

		for assets_path in assets_folders:
			if not os.access(assets_path, os.R_OK):
				continue

			subfolders = os.listdir(assets_path)
			subfolders = [x for x in subfolders if x.lower() in valid_asset_subfolders]
			dest_subfolders = [x.lower() for x in subfolders]

			subfolders_paths = [join(assets_path, x) for x in subfolders]
			dest_subfolders_paths = [join(application_path, x) for x in dest_subfolders]

			for src, dest in zip(subfolders_paths, dest_subfolders_paths):
				files = os.listdir(src)
				files = [x for x in files if os.path.isfile(join(src, x)) and predicate(join(src, x))]
				for x in files:
					copy_file_lazy(join(src, x), join(dest, x))

if __name__ == '__main__':
	distribution_path = os.getenv('ABBYY_RTR_SDK_DISTRIBUTION_ROOT',
		join(os.path.dirname(os.path.abspath(__file__)), '..'))
	default_assets_path = join(distribution_path, 'assets')

	datacapture_assets_path = join(distribution_path, 'scenarios-datacapture/assets')
	passport_ru_assets_path = join(distribution_path, 'scenarios-datacapture/ru-passport/assets')

	textcapture_assets = {
		assets_folders_key: [default_assets_path],
		valid_asset_subfolders_key: ['dictionaries', 'patterns'],
		predicate_key: lambda x: x.endswith('.edc') or x.endswith('.rom')
	}

	businesscards_capture_assets = {
		assets_folders_key: [default_assets_path],
		valid_asset_subfolders_key: ['bcr', 'dictionaries', 'patterns'],
		predicate_key: lambda x: textcapture_assets[predicate_key](x) or x.endswith('.akw')
	}

	image_capture_assets = {
		assets_folders_key: [default_assets_path],
		valid_asset_subfolders_key: ['patterns'],
		predicate_key: lambda x: x.endswith('.imodel')
	}

	datacapture_assets = {
		assets_folders_key: [default_assets_path, datacapture_assets_path, passport_ru_assets_path],
		valid_asset_subfolders_key: ['dictionaries', 'patterns'],
		predicate_key: lambda x: textcapture_assets[predicate_key](x) and not x.endswith('_EDC.rom')
	}

	datacapture_extended_assets = {
		assets_folders_key: [datacapture_assets_path],
		valid_asset_subfolders_key: ['patterns'],
		predicate_key: lambda x: x.endswith('_EDC.rom') and not x.endswith('All_EDC.rom')
	}

	datacapture_custom_extended_assets = {
		assets_folders_key: [datacapture_assets_path],
		valid_asset_subfolders_key: ['patterns'],
		predicate_key: lambda x: x.endswith('All_EDC.rom')
	}

	datacapture_extended_mrz_assets = {
		assets_folders_key: [datacapture_assets_path],
		valid_asset_subfolders_key: ['patterns'],
		predicate_key: lambda x: x.endswith('MRZ_EDC.rom')
	}

	translation_assets = {
		assets_folders_key: [default_assets_path],
		valid_asset_subfolders_key: ['dictionaries', 'patterns', 'translation'],
		predicate_key: lambda x: textcapture_assets[predicate_key](x) or x.endswith('.trdic')
	}

	copy_settings = {
		'all': [image_capture_assets, textcapture_assets, datacapture_assets,
			businesscards_capture_assets, datacapture_extended_assets, translation_assets],
		'textcapture': [textcapture_assets],
		'imagecapture': [image_capture_assets],
		'textcapture_businesscards': [textcapture_assets, businesscards_capture_assets],
		'datacapture_mrz': [businesscards_capture_assets, datacapture_assets,
			datacapture_extended_mrz_assets],
	}

	import sys
	argv = sys.argv
	scenario = 'all'
	if len(argv) > 1:
		scenario = argv[1]

	if not scenario in copy_settings:
		print('Invalid key: <{}>. Possible keys:\n\t{}'.format(scenario, '\n\t'.join(copy_settings.keys())))
		exit(1)

	copy_assets(copy_settings[scenario])
