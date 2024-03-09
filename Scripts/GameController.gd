class_name GameController

extends LocalizableCanvasLayer

@export var init_thorns_num_quick: int = 10
@export var init_thorns_num_long: int = 20
@export var cells_num_hor_quick: int = 5
@export var cells_num_hor_long: int = 10
@export var cells_num_ver_quick: int = 5
@export var cells_num_ver_long: int = 10
@export var double_attack_on_every_round_quick: int = 2
@export var double_attack_on_every_round_long: int = 4
@export var init_timer_sec_quick: float = 15
@export var init_timer_sec_long: float = 30
@export var timer_reduce_delta_sec_quick: float = 3
@export var timer_reduce_delta_sec_long: float = 3
@export var remove_all_pause_sec: float = 0.05
@export var remove_thorn_pause_sec: float = 0.1
@export var before_attack_pause_sec: float = 1.0
@export var message_label_start_localization_key: String = "MessageLabel.Start"
@export var message_label_finish_localization_key: String = "MessageLabel.Finish"

var _init_thorns_num: int
var _cells_num_hor: int
var _cells_num_ver: int
var _double_attack_on_every_round: int
var _init_timer_sec: int
var _timer_reduce_delta_sec: int
var _current_init_timer_sec: int
var _current_thorns_num: int
var _thorns_remaining: int
var _round_number: int = 0
var _round_value_label: Label
var _thorns_value_label: Label
var _timer_value_label: Label
var _message_label: Label
var _field: Field
var _menu: ColorRect
var _next_attacks: Array[Field.AttackDirection]
var _all_directions: Array
var _can_move: bool
var _save_data: SaveData
var _timer: Timer
var _is_mouse_button_pressed: bool = false
var _current_cell_processing: CellProcessingType = CellProcessingType.NONE
var _direction_sign_first: DirectionSign
var _direction_sign_second: DirectionSign
var _por_anim_player: AnimationPlayer
var _cat_anim_player: AnimationPlayer
var _big_paw_anim_player: AnimationPlayer

enum CellProcessingType { SET, REMOVE, NONE }

func _ready():
	EventBus.set_thorn_request.connect(_try_set_thorn)
	EventBus.remove_thorn_request.connect(_try_remove_thorn)
	EventBus.no_cells_for_thorns.connect(_finish_round)
	_round_value_label = get_node("DownPanel/RoundValueLabel")
	_thorns_value_label = get_node("DownPanel/ThornsValueLabel")
	_timer_value_label = get_node("UpperPanel/TimerValueLabel")
	_message_label = get_node("MenuPanel/MessageLabel")
	_timer = get_node("Timer")
	_field = get_node("Field")
	_menu = get_node("MenuPanel")
	_direction_sign_first = get_node("UpperPanel/DirectionSignFirst")
	_direction_sign_second = get_node("UpperPanel/DirectionSignSecond")
	_por_anim_player = get_node("Porcupine/AnimationPlayer")
	_cat_anim_player = get_node("Cat/AnimationPlayer")
	_big_paw_anim_player = get_node("BigPaw/AnimationPlayer")
	_save_data = SaveManager.load()
	_localize_stuff()
	_process_mode()
	_init_directions_stuff()
	_open_menu(_localization(message_label_start_localization_key))

func _process(delta: float):
	_timer_value_label.text = str(_timer.time_left as int)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		_is_mouse_button_pressed = event.pressed
		if not _is_mouse_button_pressed:
			_current_cell_processing = CellProcessingType.NONE

func _process_mode():
	match GameSettings.current_mode:
		GameSettings.Mode.QUICK:
			_init_thorns_num = init_thorns_num_quick
			_cells_num_hor = cells_num_hor_quick
			_cells_num_ver = cells_num_ver_quick
			_double_attack_on_every_round = double_attack_on_every_round_quick
			_init_timer_sec = init_timer_sec_quick
			_timer_reduce_delta_sec = timer_reduce_delta_sec_quick
		GameSettings.Mode.LONG:
			_init_thorns_num = init_thorns_num_long
			_cells_num_hor = cells_num_hor_long
			_cells_num_ver = cells_num_ver_long
			_double_attack_on_every_round = double_attack_on_every_round_long
			_init_timer_sec = init_timer_sec_long
			_timer_reduce_delta_sec = timer_reduce_delta_sec_long

func _open_menu(text: String):
	_message_label.text = text
	_menu.show()
	_field.hide()

func _new_game():
	_round_value_label.text = ""
	_thorns_value_label.text = ""
	_direction_sign_first.clear()
	_direction_sign_second.clear()
	_field.show()
	_field.init(_cells_num_hor, _cells_num_ver, remove_all_pause_sec, remove_thorn_pause_sec)
	_field.reset_cells_thorned()
	_menu.hide()
	_current_thorns_num = _init_thorns_num
	_thorns_remaining = 0
	_round_number = 0
	_current_init_timer_sec = _init_timer_sec
	_next_round()
	
func _back_to_menu():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func _try_set_thorn(x: int, y: int, is_strong: bool):
	if _current_cell_processing == CellProcessingType.REMOVE:
		return
	if not is_strong and not _is_mouse_button_pressed:
		return
	if _current_thorns_num > 0 and _can_move:
		_current_cell_processing = CellProcessingType.SET
		_take_thorn()
		EventBus.set_thorn.emit(x, y)

func _try_remove_thorn(x: int, y: int, is_strong: bool):
	if _current_cell_processing == CellProcessingType.SET:
		return
	if not is_strong and not _is_mouse_button_pressed:
		return
	if _can_move:
		_current_cell_processing = CellProcessingType.REMOVE
		_return_thorn()
		EventBus.remove_thorn.emit(x, y)

func _take_thorn():
	_current_thorns_num -= 1
	_thorns_value_label.text = str(_current_thorns_num)
	if _current_thorns_num == 0:
		_finish_round()

func _return_thorn():
	_current_thorns_num += 1
	_thorns_value_label.text = str(_current_thorns_num)

func _init_directions_stuff():
	for direction in Field.AttackDirection:
		_all_directions.push_back(direction)
		
func _finish_round():
	_por_anim_player.play("porcupine_brrr")
	_cat_anim_player.play("cat_brrr")
	_can_move = false
	_timer.stop()
	_thorns_remaining = _current_thorns_num
	await get_tree().create_timer(before_attack_pause_sec).timeout
	for attack in _next_attacks:
		var anim_name = str(Field.AttackDirection.keys()[attack]).to_lower()
		_big_paw_anim_player.play(anim_name)
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
	_por_anim_player.play("porcupine_nodding")
	_cat_anim_player.play("cat_nodding")
	_current_thorns_num = _thorns_remaining + max(_init_thorns_num - _round_number, 0)
	if (!_field.has_salami_left()):
		_process_game_over()
		return
	_round_number = _round_number + 1
	_update_timer()
	_generate_next_attacks()
	_update_statuses()
	_restart_timer()
	if _current_thorns_num != 0:
		_can_move = true
	else:
		_finish_round()

func _process_game_over():
	_por_anim_player.stop()
	_cat_anim_player.stop()
	_direction_sign_first.stop_animation()
	_direction_sign_second.stop_animation()
	var localization = _localization(message_label_finish_localization_key)
	var result_string = str(localization, _round_number)
	var record_round: int
	match GameSettings.current_mode:
		GameSettings.Mode.QUICK:
			record_round = _save_data.record_round_quick
		GameSettings.Mode.LONG:
			record_round = _save_data.record_round_long
	if _round_number > record_round:
		result_string = str(result_string, "\nrecord!")
		match GameSettings.current_mode:
			GameSettings.Mode.QUICK:
				_save_data.record_round_quick = _round_number
			GameSettings.Mode.LONG:
				_save_data.record_round_long = _round_number
		SaveManager.save(_save_data)
	_open_menu(result_string)

func _update_statuses():
	_round_value_label.text = str(_round_number)
	_thorns_value_label.text = str(_current_thorns_num)
	_direction_sign_first.clear()
	_direction_sign_second.clear()
	_direction_sign_first.stop_animation()
	_direction_sign_second.stop_animation()
	if _next_attacks.size() == 1:
		_direction_sign_second.set_direction(_next_attacks[0])
		_direction_sign_second.play_animation()
	elif _next_attacks.size() == 2:
		_direction_sign_first.set_direction(_next_attacks[0])
		_direction_sign_second.set_direction(_next_attacks[1])
		_direction_sign_first.play_animation()
		_direction_sign_second.play_animation()

func _update_timer():
	if _round_number % 4 == 0:
		_current_init_timer_sec -= _timer_reduce_delta_sec

func _restart_timer():
	_timer_value_label.text = str(_current_init_timer_sec)
	_timer.wait_time = _current_init_timer_sec
	_timer.start()

func _localization(key: String):
	return LocalManager.localization.get(key)

func _process_timer_timeout():
	_finish_round()

func _on_replay_button_pressed():
	_new_game()

func _on_next_button_pressed():
	_finish_round()

func _on_play_button_pressed():
	_new_game()

func _on_menu_button_pressed():
	_back_to_menu()

func _on_timer_timeout():
	_process_timer_timeout()
