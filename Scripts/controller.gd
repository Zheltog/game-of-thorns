class_name GameController

extends CanvasLayer

@export var initial_thorns_num: int
@export var cells_num_hor: int
@export var cells_num_ver: int

var _current_thorns_num: int
var _round_number: int = 0
var _label: Label
var _field: Field
var _next_direction: Field.AttackDirection = Field.AttackDirection.UP
var _all_directions: Array

func _ready():
	GameControllerProxy.init(self)
	_label = get_node("StatusLabel")
	_field = get_node("Field")
	_field.init(cells_num_hor, cells_num_ver)
	_current_thorns_num = initial_thorns_num
	_round_number = 0
	_init_directions_array()
	_next_round()

func _process(delta):
	pass
	
func can_take_thorn():
	return _current_thorns_num > 0

func take_thorn():
	_current_thorns_num = _current_thorns_num - 1
	_label.text = str(_current_thorns_num, " thorns remaining")
	if _current_thorns_num == 0:
		_finish_round()
		
func _init_directions_array():
	for direction in Field.AttackDirection:
		_all_directions.push_back(direction)
		
func _finish_round():
	await _field.attack_on_salami(_next_direction)
	_next_round()
	
func _set_random_next_attack_direction():
	var random_index: int = randi() % (_all_directions.size() - 1)
	var random_direction: Field.AttackDirection = Field.AttackDirection.get(_all_directions[random_index])
	_next_direction = random_direction
	
func _next_round():
	_current_thorns_num = initial_thorns_num - _round_number
	if _current_thorns_num == 0:
		_label.text = str("Game over\nNo thorns remaining\nYou reached round ", _round_number)
		return
	if (!_field.has_salami_left()):
		_label.text = str("Game over\nNo salami remaining\nYou reached round ", _round_number)
		return
	_round_number = _round_number + 1
	_set_random_next_attack_direction()
	var next_direction_str: String = Field.AttackDirection.keys()[_next_direction]
	if _round_number == 1:
		_label.text = str("Round #1\nProtect salami with your thorns!\nNext attack: ", next_direction_str)
		return
	_label.text = str("Round #", _round_number, "\nYou got ", _current_thorns_num, " thorns\nNext attack: ", next_direction_str)
