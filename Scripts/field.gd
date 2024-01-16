class_name Field

extends Node2D

enum AttackDirection { UP, DOWN, LEFT, RIGHT }

var _cells_num_hor: int
var _cells_num_ver: int
var _cell_size: int
var _cells_remaining: int
var _center: Vector2
var _cells: Array
var _scene: PackedScene = load("res://cell.tscn")

func _ready():
	EventBus.set_thorn.connect(_set_thorn)
	
func init(cells_num_hor: int, cells_num_ver: int):
	_cells_num_hor = cells_num_hor
	_cells_num_ver = cells_num_ver
	_cells_remaining = cells_num_hor * cells_num_ver
	var screen_width = get_viewport_rect().size.x
	var screen_height = get_viewport_rect().size.y
	_center = Vector2(screen_width / 2, screen_height / 2)
	_cell_size = screen_width / (cells_num_hor + 2)
	_init_cells()
			
func has_salami_left():
	return _cells_remaining > 0

func attack_on_salami(direction: AttackDirection):
	match(direction):
		AttackDirection.UP:
			await _attack_from_down_to_up()
		AttackDirection.DOWN:
			await _attack_from_up_to_down()
		AttackDirection.LEFT:
			await _attack_from_right_to_left()
		AttackDirection.RIGHT:
			await _attack_from_left_to_right()

func _set_thorn(x: int, y: int):
	_cells[x * _cells_num_hor + y].set_thorn()

func _init_cells():
	_cells.resize(_cells_num_hor * _cells_num_ver)
	var left_top_x = _center.x - (_cells_num_hor * _cell_size / 2)
	var left_top_y = _center.y - (_cells_num_ver * _cell_size / 2)
	var init_pos_x = left_top_x + _cell_size / 2
	var init_pos_y = left_top_y + _cell_size / 2
	
	for x in range(_cells_num_hor):
		for y in range(_cells_num_ver):
			var cell: Cell = _scene.instantiate()
			add_child(cell)
			cell.set_size(_cell_size, _cell_size)
			cell.set_coordinates(x, y)
			cell.name = str("Cell[", x, ",", y, "]")
			cell.position = Vector2(init_pos_x + x * _cell_size, init_pos_y + y * _cell_size)
			_cells[x * _cells_num_hor + y] = cell

func _remove_thorn_and_pause(cell: Cell):
	cell.remove_throrn()
	await get_tree().create_timer(0.1).timeout
	
func _remove_all_and_pause(cell: Cell):
	cell.remove_all()
	_cells_remaining = _cells_remaining - 1
	await get_tree().create_timer(0.0).timeout
	
func _process_and_return_was_thorned(x: int, y: int):
	var cell = _cells[x * _cells_num_hor + y]
	var status = cell.current_status
	if status == Cell.Status.THORNED:
		await _remove_thorn_and_pause(cell)
		return true
	if status == Cell.Status.SALAMI:
		await _remove_all_and_pause(cell)
	return false
	
func _attack_from_up_to_down():
	for x in range(_cells_num_hor):
		for y in range(_cells_num_ver):
			if (await _process_and_return_was_thorned(x, y)):
				break
				
func _attack_from_down_to_up():
	for x in range(_cells_num_hor):
		for y in range(_cells_num_ver - 1, -1, -1):
			if (await _process_and_return_was_thorned(x, y)):
				break
				
func _attack_from_left_to_right():
	for y in range(_cells_num_ver):
		for x in range(_cells_num_hor):
			if (await _process_and_return_was_thorned(x, y)):
				break
				
func _attack_from_right_to_left():
	for y in range(_cells_num_ver):
		for x in range(_cells_num_hor - 1, -1, -1):
			if (await _process_and_return_was_thorned(x, y)):
				break
