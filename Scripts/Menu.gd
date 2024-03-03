extends CanvasLayer

var _main_scene: PackedScene = load("res://Scenes/main.tscn")
var version_label_prefix = "ver. "

func _ready():
	var version = MetaManager.meta_data.version
	($BasePanel/VersionLabel).text = version_label_prefix + version
	_localize_stuff()

func _localize_stuff():
	var localizable = get_tree().get_nodes_in_group(LocalManager.localizable_group_name)
	for node in localizable:
		var node_class = node.get_class()
		match node_class:
			"Button":
				LocalManager.try_localize_button(node)

func _on_play_quick_button_pressed():
	_play(GameSettings.Mode.QUICK)

func _on_play_long_button_pressed():
	_play(GameSettings.Mode.LONG)

func _on_stats_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/stats.tscn")

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_exit_button_pressed():
	_exit()

func _play(mode: GameSettings.Mode):
	GameSettings.current_mode = mode
	get_tree().change_scene_to_packed(_main_scene)

func _exit():
	get_tree().quit()
