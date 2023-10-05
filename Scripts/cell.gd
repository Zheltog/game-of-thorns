class_name Cell

extends Node2D

enum Status { SALAMI, THORNED, EMPTY }

var current_status = Status.SALAMI

var _base: Sprite2D
var _salami: Sprite2D
var _thorn: Sprite2D
var _initial_size_x: float
var _initial_size_y: float

func _ready():
	_base = get_node("Base")
	_salami = get_node("Salami")
	_thorn = get_node("Thorn")
	print("base = ", _base)
	_initial_size_x = _base.texture.get_width()
	_initial_size_y = _base.texture.get_height()

func _process(delta):
	pass

func set_size(size_x: float, size_y: float):
	scale = Vector2(size_x / _initial_size_x, size_y / _initial_size_y)
	
func remove_all():
	current_status = Status.EMPTY
	_base.modulate.a = 0.5
	_salami.modulate.a = 0
	_thorn.modulate.a = 0
	
func remove_throrn():
	current_status = Status.SALAMI
	_base.modulate.a = 1
	_salami.modulate.a = 1
	_thorn.modulate.a = 0

func on_button_pressed():
	_try_set_thorn()

func _try_set_thorn():
	if GameControllerProxy.can_take_thorn() && current_status == Status.SALAMI:
		GameControllerProxy.take_thorn()
		_set_thorn()

func _set_thorn():
	current_status = Status.THORNED
	_base.modulate.a = 1
	_salami.modulate.a = 0.5
	_thorn.modulate.a = 1
