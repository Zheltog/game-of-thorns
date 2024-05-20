class_name Stats

extends LocalizableCanvasLayer

static var logo_anim_name = "logo_anim"
static var menu_scene_name = "res://Scenes/menu.tscn"

@onready var _anim_player: AnimationPlayer = $BasePanel/LogoBase/AnimationPlayer
@onready var _stats_quick_value_label: Label = $BasePanel/StatsQuickValueLabel
@onready var _stats_long_value_label: Label = $BasePanel/StatsLongValueLabel
@onready var _stats_reset_button: Button = $BasePanel/StatsResetButton

var _is_reset_confirm_requested: bool = false
var _save_data: SaveData

func _ready():
	_save_data = SaveManager.load()
	_update_value_labels()
	_localize_stuff()
	_anim_player.play(logo_anim_name)

func _update_value_labels():
	_stats_quick_value_label.text = str(_save_data.record_round_quick)
	_stats_long_value_label.text = str(_save_data.record_round_long)

func _on_back_button_pressed():
	_back()

func _on_stats_reset_button_pressed():
	if not _is_reset_confirm_requested:
		_stats_reset_button.text += "?"
		_is_reset_confirm_requested = true
	else:
		_reset()

func _reset():
	var reset_text = _stats_reset_button.text
	_stats_reset_button.text = reset_text.substr(0, reset_text.length() - 1)
	_is_reset_confirm_requested = false
	_save_data.record_round_quick = 0
	_save_data.record_round_long = 0
	SaveManager.save(_save_data)
	_update_value_labels()

func _back():
	get_tree().change_scene_to_file(menu_scene_name)
