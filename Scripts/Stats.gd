extends CanvasLayer

func _ready():
	var saved_data: SaveData = SaveManager.load()
	($BasePanel/StatsQuickValueLabel).text = str(saved_data.record_round_quick)
	($BasePanel/StatsLongValueLabel).text = str(saved_data.record_round_long)

func _on_back_button_pressed():
	_back()

func _back():
	get_tree().change_scene_to_file("res://menu.tscn")