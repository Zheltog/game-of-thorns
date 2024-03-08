class_name DirectionSign

extends Node2D

var _direction_pics: Dictionary = {}
var _current_direction: Field.AttackDirection
var _anim_player: AnimationPlayer
var _texture_rect: TextureRect

func _ready():
	_anim_player = get_node("AnimationPlayer")
	_texture_rect = get_node("TextureRect")
	for direction in Field.AttackDirection:
		var dir_str = str(direction)
		var pic_path = str("res://Sprites/", direction.to_lower(), ".png")
		_direction_pics[direction] = load(pic_path)

func set_direction(direction: Field.AttackDirection):
	_current_direction = direction
	_texture_rect.texture = _direction_pics[Field.AttackDirection.keys()[direction]]

func clear():
	_texture_rect.texture = null

func play_animation():
	var anim_name = (Field.AttackDirection.keys()[_current_direction]).to_lower()
	_anim_player.play(anim_name)

func stop_animation():
	_anim_player.stop()
