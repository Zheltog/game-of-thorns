extends LocalizableCanvasLayer

var _save_data: SaveData
var _main_scene: PackedScene = load("res://Scenes/main.tscn")
var _shop_button: Button
var version_label_prefix = "ver. "

func _ready():
	var version = MetaManager.meta_data.version
	($BasePanel/VersionLabel).text = version_label_prefix + version
	($BasePanel/LogoBase/AnimationPlayer).play("logo_anim")
	_localize_stuff()
	_shop_button = get_node("BasePanel/ShopButton")
	_save_data = SaveManager.load()
	if _save_data.ads_enabled:
		_shop_button.show()
		_download(_save_data.ad_config_link, Ad.ad_config_json_name)
	else:
		_shop_button.hide()

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

func _on_shop_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/shop.tscn")

func _play(mode: GameSettings.Mode):
	GameSettings.current_mode = mode
	get_tree().change_scene_to_packed(_main_scene)

func _exit():
	get_tree().quit()
