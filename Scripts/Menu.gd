extends CanvasLayer

var _main_scene: PackedScene = load("res://main.tscn")

func _on_play_quick_button_pressed():
	_play(GameSettings.Mode.QUICK)

func _on_play_long_button_pressed():
	_play(GameSettings.Mode.LONG)

func _on_stats_quick_button_pressed():
	pass # Replace with function body.

func _on_stats_long_button_pressed():
	pass # Replace with function body.

func _on_exit_button_pressed():
	_exit()

func _play(mode: GameSettings.Mode):
	GameSettings.current_mode = mode
	get_tree().change_scene_to_packed(_main_scene)

func _exit():
	get_tree().quit()
