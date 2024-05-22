class_name Info

extends LocalizableCanvasLayer

static var menu_scene_name = "res://Scenes/menu.tscn"
static var by_name = "info.by"
static var contacts_name = "info.contacts"
static var version_prefix_name = "info.version.prefix"
static var news_name = "info.news"

@onready var _info_text = $BasePanel/ScrollContainer/VBoxContainer/InfoText

func _ready():
	_localize_stuff()
	var by_str = LocalManager.localization.get(by_name)
	var contacts_str = LocalManager.localization.get(contacts_name)
	var version_prefix_str = LocalManager.localization.get(version_prefix_name)
	var news_str = LocalManager.localization.get(news_name)
	_info_text.text = str(by_str, "\n\n",
		contacts_str, "\n\n",
		version_prefix_str, MetaManager.meta_data.version, "\n\n",
		news_str, "\n\n",
		"TODO\nTODO\nTODO\nTODO\nTODO\nTODO\nTODO\nTODO\nTODO\nTODO\n")

func _on_back_button_pressed():
	_back()

func _back():
	get_tree().change_scene_to_file(menu_scene_name)
