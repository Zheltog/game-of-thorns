extends CanvasLayer

var save_data: SaveData

func _ready():
	save_data = SaveManager.load()
	($BasePanel/AdsCheckBox).button_pressed = save_data.ads_enabled

func _on_back_button_pressed():
	_back()

func _back():
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_ads_check_box_toggled(button_pressed):
	save_data.ads_enabled = button_pressed
	SaveManager.save(save_data)
