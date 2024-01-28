extends CanvasLayer

var _main_scene: PackedScene = load("res://main.tscn")

func _on_play_quick_button_pressed():
	_play(GameSettings.Mode.QUICK)

func _on_play_long_button_pressed():
	_play(GameSettings.Mode.LONG)

func _on_stats_button_pressed():
	var data = SaveData.new()
	data.record_round_long = 5
	data.record_round_quick = 55
	SaveManager.save(data)

func _on_settings_button_pressed():
	var loaded: SaveData = SaveManager.load()
	print(loaded.to_dictionary())

func _on_exit_button_pressed():
	_exit()

func _play(mode: GameSettings.Mode):
	GameSettings.current_mode = mode
	get_tree().change_scene_to_packed(_main_scene)

func _exit():
	get_tree().quit()
