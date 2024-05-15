extends LocalizableCanvasLayer

var _is_reset_confirm_requested: bool = false
var _stats_quick_value_label: Label
var _stats_long_value_label: Label
var _stats_reset_button: Button
var _save_data: SaveData

func _ready():
	($BasePanel/LogoBase/AnimationPlayer).play("logo_anim")
	_stats_quick_value_label = get_node("BasePanel/StatsQuickValueLabel")
	_stats_long_value_label = get_node("BasePanel/StatsLongValueLabel")
	_stats_reset_button = get_node("BasePanel/StatsResetButton")
	_save_data = SaveManager.load()
	_update_value_labels()
	_localize_stuff()

func _update_value_labels():
	_stats_quick_value_label.text = str(_save_data.record_round_quick)
	_stats_long_value_label.text = str(_save_data.record_round_long)

func _on_back_button_pressed():
	_back()

func _back():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_stats_reset_button_pressed():
	if not _is_reset_confirm_requested:
		_stats_reset_button.text += "?"
		_is_reset_confirm_requested = true
	else:
		var reset_text = _stats_reset_button.text
		_stats_reset_button.text = reset_text.substr(0, reset_text.length() - 1)
		_is_reset_confirm_requested = false
		_save_data.record_round_quick = 0
		_save_data.record_round_long = 0
		SaveManager.save(_save_data)
		_update_value_labels()
