class_name Rules

extends LocalizableCanvasLayer

static var logo_anim_name = "logo_anim"
static var main_scene_name = "res://Scenes/main.tscn"

@onready var _anim_player: AnimationPlayer = $BasePanel/LogoBase/AnimationPlayer

func _ready():
	_localize_stuff()
	_anim_player.play(logo_anim_name)

func _on_back_button_pressed():
	_back()

func _back():
	get_tree().change_scene_to_file(main_scene_name)
