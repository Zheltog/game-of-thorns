class_name Menu

extends LocalizableCanvasLayer

static var version_label_prefix = "ver. "
static var main_scene_name = "res://Scenes/main.tscn"
static var stats_scene_name = "res://Scenes/stats.tscn"
static var settings_scene_name = "res://Scenes/settings.tscn"
static var shop_scene_name = "res://Scenes/shop.tscn"
static var logo_anim_name = "logo_anim"

@onready var _shop_button: Button = $BasePanel/ShopButton
@onready var _version_label: Label = $BasePanel/VersionLabel
@onready var _anim_player: AnimationPlayer = $BasePanel/LogoBase/AnimationPlayer

var _save_data: SaveData

func _ready():
	var version = MetaManager.meta_data.version
	_version_label.text = version_label_prefix + version
	_localize_stuff()
	
	_save_data = SaveManager.load()
	print("[Menu._ready] _save_data=", _save_data)
	if _save_data.ads_enabled:
		_shop_button.show()
		_download(_save_data.ad_config_link, Ad.ad_config_json_name)
	else:
		_shop_button.hide()
	
	_anim_player.play(logo_anim_name)

func _on_play_quick_button_pressed():
	_play(GameSettings.Mode.QUICK)

func _on_play_long_button_pressed():
	_play(GameSettings.Mode.LONG)

func _on_stats_button_pressed():
	get_tree().change_scene_to_file(stats_scene_name)

func _on_settings_button_pressed():
	get_tree().change_scene_to_file(settings_scene_name)

func _on_exit_button_pressed():
	_exit()

func _on_shop_button_pressed():
	get_tree().change_scene_to_file(shop_scene_name)

func _play(mode: GameSettings.Mode):
	GameSettings.current_mode = mode
	get_tree().change_scene_to_file(main_scene_name)

func _exit():
	get_tree().quit()
