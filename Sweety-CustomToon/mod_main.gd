extends Node


const GODOTMODDING_EXAMPLEMOD_DIR := "Sweety-CustomToon"
const GODOTMODDING_EXAMPLEMOD_LOG_NAME := "Sweety-CustomToon:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(GODOTMODDING_EXAMPLEMOD_DIR)
	# Add extensions
	install_script_extensions()
	install_script_hook_files()
	# Add translations
	add_translations()


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	# ModLoaderMod.install_script_extension(extensions_dir_path.path_join(...))

func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_hooks("res://scenes/title_screen/title_screen.gd", extensions_dir_path.path_join("scenes/title_screen/title_screen.hooks.gd"))
	#ModLoaderMod.install_script_hooks("res://objects/pause_menu/pause_menu.gd", extensions_dir_path.path_join("objects/pause_menu/pause_menu.hooks.gd"))



func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")
	# ModLoaderMod.add_translation(translations_dir_path.path_join(...))


func _ready() -> void:
	
	ModLoaderLog.info("Ready!", GODOTMODDING_EXAMPLEMOD_LOG_NAME)
