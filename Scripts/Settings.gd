extends LocalizableCanvasLayer

var save_data: SaveData
var lang_options: OptionButton
var lang_button: Button
var lang_popup: PopupMenu
var ads_check_box: CheckBox

func _ready():
	save_data = SaveManager.load()
	lang_options = get_node("BasePanel/LangOptionButton")
	lang_button = get_node("BasePanel/LangButton")
	lang_popup = get_node("BasePanel/LangPopupMenu")
	ads_check_box = get_node("BasePanel/AdsCheckBox")
	ads_check_box.button_pressed = save_data.ads_enabled
	
	_init_lang_options()
	_localize_stuff()

func _init_lang_options():
	var lang_names = LocalManager.lang_names()
	var idx = 0
	var current_idx = -1
	for lang in lang_names:
		lang_options.add_item(lang, idx)
		lang_popup.add_item(lang, idx)
		if lang == save_data.lang:
			current_idx = idx
			lang_button.text = lang
		idx += 1
	lang_options.select(current_idx)

func _on_back_button_pressed():
	_back()

func _back():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_ads_check_box_toggled(button_pressed):
	save_data.ads_enabled = button_pressed
	SaveManager.save(save_data)

func _on_lang_option_button_item_selected(index):
	var lang = ($BasePanel/LangOptionButton).get_item_text(index)
	save_data.lang = lang
	SaveManager.save(save_data)
	LocalManager.set_localization(lang)
	_localize_stuff()

func _on_lang_button_pressed():
	lang_button.hide()
	lang_popup.popup(Rect2i(lang_button.position.x, lang_button.position.y, lang_button.size.x, lang_button.size.y))

func _on_lang_popup_menu_index_pressed(index):
	var lang = ($BasePanel/LangOptionButton).get_item_text(index)
	save_data.lang = lang
	SaveManager.save(save_data)
	LocalManager.set_localization(lang)
	_localize_stuff()
	lang_button.text = lang
	lang_popup.hide()

func _on_lang_popup_menu_popup_hide():
	lang_button.show()
