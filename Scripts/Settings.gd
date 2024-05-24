class_name Settings

extends LocalizableCanvasLayer

static var logo_anim_name = "logo_anim"
static var menu_scene_name = "res://Scenes/menu.tscn"
static var log_scene_name = "res://Scenes/log.tscn"

@onready var _ads_check_box: CheckBox = $BasePanel/AdsCheckBox
@onready var _lang_button: Button = $BasePanel/LangButton
@onready var _lang_popup: PopupMenu = $BasePanel/LangPopupMenu
@onready var _anim_player: AnimationPlayer = $BasePanel/LogoBase/AnimationPlayer
@onready var _settings_label: Label = $BasePanel/SettingsLabel

var _save_data: SaveData
var _rm_clicks: int = 0
var _rm_clicks_to_rm: int = 3

func _ready():
	_save_data = SaveManager.load()
	_ads_check_box.button_pressed = _save_data.ads_enabled
	_init_lang_options()
	_localize_stuff()
	_anim_player.play(logo_anim_name)

func _init_lang_options():
	var lang_names = LocalManager.lang_names()
	var idx = 0
	var current_idx = -1
	for lang in lang_names:
		_lang_popup.add_item(lang, idx)
		if lang == _save_data.lang:
			current_idx = idx
			_lang_button.text = lang
		idx += 1

func _on_ads_check_box_toggled(button_pressed):
	_save_data.ads_enabled = button_pressed
	SaveManager.save(_save_data)

func _on_lang_button_pressed():
	_lang_button.hide()
	_lang_popup.popup(Rect2i(_lang_button.position.x, _lang_button.position.y, 
		_lang_button.size.x, _lang_button.size.y))

func _on_back_button_pressed():
	_back()

func _back():
	get_tree().change_scene_to_file(menu_scene_name)

func _on_lang_popup_menu_index_pressed(index):
	var lang = _lang_popup.get_item_text(index)
	_save_data.lang = lang
	SaveManager.save(_save_data)
	LocalManager.set_localization(lang)
	_localize_stuff()
	_lang_button.text = lang
	_lang_popup.hide()

func _on_lang_popup_menu_popup_hide():
	_lang_button.show()

func _on_log_button_pressed():
	get_tree().change_scene_to_file(log_scene_name)

# DEV STUFF
func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		var settings_bounds = Rect2(
			_settings_label.position, _settings_label.size)
		if settings_bounds.has_point(event.position) or settings_bounds.has_point(event.position):
			_rm_clicks += 1
			if _rm_clicks == _rm_clicks_to_rm:
				_rm_clicks = 0
				_clear_user_data()

# DEV STUFF
func _clear_user_data():
	print("[Settings._clear_user_data]")
	var new_save_data = SaveData.new({})
	SaveManager.save(new_save_data)
	_delete_file("res://adconf.json")
	_delete_file("res://adpic.jpg")
	_delete_file("res://adpic.jpg.import")
	_delete_file("user://adconf.json")
	_delete_file("user://adpic.jpg")
	_delete_file("user://adpic.jpg.import")
	_process_res_content()
	_process_user_content()

# DEV STUFF
func _delete_file(path: String):
	print("[Settings._delete_file] path=", path)
	var error = DirAccess.remove_absolute(path)
	print("[Settings._delete_file] error=", error)

# DEV STUFF
func _process_res_content():
	print("[Settings._process_res_content]")
	var dir = DirAccess.open("res://")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("[Settings._process_res_content] dir: " + file_name)
			else:
				print("[Settings._process_res_content] file: " + file_name)
			file_name = dir.get_next()
	else:
		print("[Settings._process_res_content] ERROR")

# DEV STUFF
func _process_user_content():
	print("[Settings._process_user_content]")
	var dir = DirAccess.open("user://")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("[Settings._process_user_content] dir: " + file_name)
			else:
				print("[Settings._process_user_content] file: " + file_name)
			file_name = dir.get_next()
	else:
		print("[Settings._process_user_content] ERROR")
