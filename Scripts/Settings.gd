class_name Settings

extends LocalizableCanvasLayer

static var logo_anim_name = "logo_anim"

@onready var _ads_check_box: CheckBox = $BasePanel/AdsCheckBox
@onready var _lang_button: Button = $BasePanel/LangButton
@onready var _lang_popup: PopupMenu = $BasePanel/LangPopupMenu
@onready var _anim_player: AnimationPlayer = $BasePanel/LogoBase/AnimationPlayer

var _save_data: SaveData

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
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

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
