extends Node

static var langs_file_name: String = "res://Jsons/l.json"

var localization: Dictionary = {}
var langs: Dictionary

func _ready():
	langs = StorageManager.read_from(langs_file_name)
	var save_data: SaveData = SaveManager.load()
	var lang = save_data.lang
	if lang != null:
		set_localization(lang)

func set_localization(lang: String):
	var code = langs.get(lang)
	if code == null:
		print("Error! Unknown language: ", lang)
		return
	var local_file_name = str("res://Jsons/", code, ".json")
	localization = StorageManager.read_from(local_file_name)
	pass

func try_localize_button(button: Button, text_postfix: String = ""):
	var localization_str = _get_value_for(button)
	if localization_str != null:
		button.text = localization_str + text_postfix

func try_localize_label(label: Label, text_postfix: String = ""):
	var localization_str = _get_value_for(label)
	if localization_str != null:
		label.text = localization_str + text_postfix

func _get_value_for(node: Node) -> String:
	return localization.get(node.name)
