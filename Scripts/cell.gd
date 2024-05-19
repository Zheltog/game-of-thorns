class_name Cell

extends Node2D

enum Status { SALAMI, THORNED, EMPTY }

var current_status = Status.SALAMI

@onready var _base: Sprite2D = $Base
@onready var _salami: Sprite2D = $Salami
@onready var _thorn: Sprite2D = $Thorn

var _initial_size_x: float
var _initial_size_y: float
var _x: int
var _y: int

func _ready():
	_initial_size_x = _base.texture.get_width()
	_initial_size_y = _base.texture.get_height()

func set_coordinates(x: int, y: int):
	_x = x
	_y = y

func set_size(size_x: float, size_y: float):
	scale = Vector2(size_x / _initial_size_x, size_y / _initial_size_y)

func set_thorn():
	current_status = Status.THORNED
	_base.modulate.a = 1
	_salami.modulate.a = 0.5
	_thorn.modulate.a = 1

func remove_thorn():
	current_status = Status.SALAMI
	_base.modulate.a = 1
	_salami.modulate.a = 1
	_thorn.modulate.a = 0

func remove_all():
	current_status = Status.EMPTY
	_base.modulate.a = 0.5
	_salami.modulate.a = 0
	_thorn.modulate.a = 0

func _on_button_button_down():
	if current_status == Status.SALAMI:
		EventBus.set_thorn_request.emit(_x, _y, true)
	elif current_status == Status.THORNED:
		EventBus.remove_thorn_request.emit(_x, _y, true)

func _on_button_mouse_entered():
	if current_status == Status.SALAMI:
		EventBus.set_thorn_request.emit(_x, _y, false)
	elif current_status == Status.THORNED:
		EventBus.remove_thorn_request.emit(_x, _y, false)
