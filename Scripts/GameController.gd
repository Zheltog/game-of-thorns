class_name GameController

extends CanvasLayer

@export var initial_thorns_num: int
@export var cells_num_hor: int
@export var cells_num_ver: int
@export var remove_all_pause_sec: float = 0.05
@export var remove_thorn_pause_sec: float = 0.1
@export var idle_round_pause_sec: float = 1.0

var _current_thorns_num: int
var _round_number: int = 0
var _round_value_label: Label
var _thorns_value_label: Label
var _next_attacks_value_label: Label
var _message_label: Label
var _field: Field
var _menu: ColorRect
var _next_attacks: Array[Field.AttackDirection]
var _all_directions: Array
var _can_move: bool

func _ready():
	EventBus.cell_pressed.connect(_try_set_thorn)
	EventBus.no_cells_for_thorns.connect(_finish_round)
	_round_value_label = get_node("StatusPanel/RoundValueLabel")
	_thorns_value_label = get_node("StatusPanel/ThornsValueLabel")
	_next_attacks_value_label = get_node("StatusPanel/NextAttacksValueLabel")
	_message_label = get_node("MenuPanel/MessageLabel")
	_field = get_node("Field")
	_menu = get_node("MenuPanel")
	_process_mode()
	_init_directions_array()
	_open_menu("protect salami with your thorns!")

func _process_mode():
	var mode = GameSettings.current_mode
	print("mode = ", mode)

func _open_menu(text: String):
	_message_label.text = text
	_menu.show()
	_field.hide()

func _new_game():
	_round_value_label.text = ""
	_thorns_value_label.text = ""
	_next_attacks_value_label.text = ""
	_field.show()
	_field.init(cells_num_hor, cells_num_ver, remove_all_pause_sec, remove_thorn_pause_sec)
	_field.reset_cells_thorned()
	_menu.hide()
	_current_thorns_num = initial_thorns_num
	_round_number = 0
	_next_round()
	
func _back_to_menu():
	get_tree().change_scene_to_file("res://menu.tscn")
	
func _try_set_thorn(x: int, y: int):
	if _current_thorns_num > 0 and _can_move:
		_take_thorn()
		EventBus.set_thorn.emit(x, y)

func _take_thorn():
	_current_thorns_num = _current_thorns_num - 1
	_thorns_value_label.text = str(_current_thorns_num)
	if _current_thorns_num == 0:
		_finish_round()
		
func _init_directions_array():
	for direction in Field.AttackDirection:
		_all_directions.push_back(direction)
		
func _finish_round():
	_can_move = false
	for attack in _next_attacks:
		await _field.attack_on_salami(attack)
	_next_round()
	
func _generate_next_attacks():
	var attacks_num = 2 if _round_number % 4 == 0 else 1
	_next_attacks.resize(attacks_num)
	for i in range(attacks_num):
		var random_index: int = randi() % (_all_directions.size() - 1)
		var random_direction: Field.AttackDirection = Field.AttackDirection.get(_all_directions[random_index])
		_next_attacks[i] = random_direction
	
func _next_round():
	_current_thorns_num = initial_thorns_num - _round_number
	_current_thorns_num = max(_current_thorns_num, 0)
	if (!_field.has_salami_left()):
		_open_menu(str("game over\nno salami remaining\nyou reached round ", _round_number))
		return
	_round_number = _round_number + 1
	_generate_next_attacks()
	_update_statuses()
	if _current_thorns_num != 0:
		_can_move = true
	else:
		await get_tree().create_timer(idle_round_pause_sec).timeout
		_finish_round()

func _update_statuses():
	_round_value_label.text = str(_round_number)
	_thorns_value_label.text = str(_current_thorns_num)
	var next_attacks_str = ""
	for i in range(_next_attacks.size()):
		var attack = _next_attacks[i]
		var attack_str = (Field.AttackDirection.keys()[attack] as String).substr(0, 1)
		if i == 0:
			next_attacks_str += attack_str
		else:
			next_attacks_str += "+" + attack_str
	_next_attacks_value_label.text = next_attacks_str

func _on_new_game_button_pressed():
	_new_game()

func _on_menu_button_pressed():
	_back_to_menu()
