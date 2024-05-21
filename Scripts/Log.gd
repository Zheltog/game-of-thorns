class_name Log

extends LocalizableCanvasLayer

static var settings_scene_name = "res://Scenes/settings.tscn"
static var log_file_name = "user://logs/godot.log"

@onready var _log_text: Label = $BasePanel/LogText

func _ready():
	var log_text = StorageManager.read_from_as_string(log_file_name)
	_log_text.text = log_text
	_localize_stuff()

func _on_back_button_pressed():
	_back()

func _back():
	get_tree().change_scene_to_file(settings_scene_name)
