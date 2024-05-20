class_name GameController

extends LocalizableCanvasLayer

static var message_label_start_localization_key = "MessageLabel.Start"
static var message_label_finish_localization_key = "MessageLabel.Finish"
static var message_label_record_localization_key = "MessageLabel.Record"
static var menu_scene_name = "res://Scenes/menu.tscn"
static var rules_scene_name = "res://Scenes/rules.tscn"
static var cat_nodding_anim_name = "cat_nodding"
static var porcupine_nodding_anim_name = "porcupine_nodding"
static var cat_brrr_anim_name = "cat_brrr"
static var porcupine_brrr_anim_name = "porcupine_brrr"
static var thorn_name = "thorn"

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

@onready var _direction_sign_first: DirectionSign = $UpperPanel/DirectionSignFirst
@onready var _direction_sign_second: DirectionSign = $UpperPanel/DirectionSignSecond
@onready var _timer_value_label: Label = $UpperPanel/TimerValueLabel
@onready var _round_value_label: Label = $DownPanel/RoundValueLabel
@onready var _thorns_value_label: Label = $DownPanel/ThornsValueLabel
@onready var _menu: ColorRect = $MenuPanel
@onready var _message_label: Label = $MenuPanel/MessageLabel
@onready var _items_info: ColorRect = $ItemsInfoPanel
@onready var _items_info_label: Label = $ItemsInfoPanel/ItemsInfoLabel
@onready var _por_anim_player: AnimationPlayer = $Porcupine/AnimationPlayer
@onready var _cat_anim_player: AnimationPlayer = $Cat/AnimationPlayer
@onready var _big_paw_anim_player: AnimationPlayer = $BigPaw/Base/AnimationPlayer
@onready var _timer: Timer = $Timer
@onready var _field: Field = $Field
@onready var _ad: Ad = $Ad

var _init_thorns_num: int
var _cells_num_hor: int
var _cells_num_ver: int
var _double_attack_on_every_round: int
var _init_timer_sec: int
var _timer_reduce_delta_sec: int
var _current_init_timer_sec: int
var _current_thorns_num: int
var _thorns_remaining: int
var _extra_thorns: int = 0
var _round_number: int = 0
var _current_cell_processing: CellProcessingType = CellProcessingType.NONE
var _next_attacks: Array[Field.AttackDirection]
var _all_directions: Array
var _can_move: bool
var _is_mouse_button_pressed: bool = false
var _ads_enabled: bool
var _ad_pic_initialized: bool = false
var _ad_view_price: int
var _items: Dictionary
var _save_data: SaveData

enum CellProcessingType { SET, REMOVE, NONE }

func _ready():
	EventBus.set_thorn_request.connect(_try_set_thorn)
	EventBus.remove_thorn_request.connect(_try_remove_thorn)
	EventBus.no_cells_for_thorns.connect(_finish_round)
	EventBus.close_ad.connect(_close_ad)
	_items_info.hide()
	_save_data = SaveManager.load()
	_localize_stuff()
	_process_mode()
	_init_directions_stuff()
	_open_menu(_localization(message_label_start_localization_key))
	_ad.hide()
	_ads_enabled = _save_data.ads_enabled
	if _ads_enabled:
		_process_ads_enabled()

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

func _init_directions_stuff():
	for direction in Field.AttackDirection:
		_all_directions.push_back(direction)

func _open_menu(text: String):
	_message_label.text = text
	_menu.show()
	_field.hide()

func _process_ads_enabled():
	_items = _save_data.items
	var ad_config_dict = StorageManager.read_from(Ad.ad_config_json_name)
	var ad_config = AdConfig.new(ad_config_dict)
	_ad_view_price = ad_config.view_price
	_save_data.ad_pic_link = ad_config.pic_link
	_save_data.ad_click_link = ad_config.click_link
	SaveManager.save(_save_data)
	_download(ad_config.pic_link, Ad.ad_pic_name)

func _restart_game():
	if _ads_enabled:
		_timer.stop()
		_show_ad()
	else:
		_new_game()

func _show_ad():
	if not _ad_pic_initialized:
		_ad.update_pic()
		_ad_pic_initialized = true
	_ad.show()
	_save_data.cash += _ad_view_price
	SaveManager.save(_save_data)

func _new_game():
	if not _items.is_empty():
		_process_items()
		return
	_round_value_label.text = ""
	_thorns_value_label.text = ""
	_direction_sign_first.clear()
	_direction_sign_second.clear()
	_field.show()
	_field.init(_cells_num_hor, _cells_num_ver, remove_all_pause_sec, remove_thorn_pause_sec)
	_field.reset_cells_thorned()
	_current_thorns_num = _init_thorns_num
	_thorns_remaining = _extra_thorns
	_current_init_timer_sec = _init_timer_sec
	_extra_thorns = 0
	_round_number = 0
	_next_round()

func _process_items():
	_items_info.show()
	var _items_string: String
	for _item_name in _items:
		var localization_name = str(_item_name, Good.name_postfix)
		var localization = LocalManager.localization.get(localization_name)
		var count = _items[_item_name]
		if _item_name == thorn_name:
			_extra_thorns = count
		_items_string += localization + ": " + str(count) + "\n"
	var _original_info_text = _items_info_label.text
	_items_info_label.text += str("\n\n", _items_string)
	_items.clear()
	_save_data.items = _items
	SaveManager.save(_save_data)

func _next_round():
	_por_anim_player.play(porcupine_nodding_anim_name)
	_cat_anim_player.play(cat_nodding_anim_name)
	_current_thorns_num = _thorns_remaining + max(_init_thorns_num - _round_number, 0)
	if not _field.has_salami_left():
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
	var finish_localization = _localization(message_label_finish_localization_key)
	var result_string = str(finish_localization, _round_number)
	var record_round: int
	match GameSettings.current_mode:
		GameSettings.Mode.QUICK:
			record_round = _save_data.record_round_quick
		GameSettings.Mode.LONG:
			record_round = _save_data.record_round_long
	if _round_number > record_round:
		var record_localization = _localization(message_label_record_localization_key)
		result_string = str(result_string, "\n", record_localization)
		match GameSettings.current_mode:
			GameSettings.Mode.QUICK:
				_save_data.record_round_quick = _round_number
			GameSettings.Mode.LONG:
				_save_data.record_round_long = _round_number
		SaveManager.save(_save_data)
	_open_menu(result_string)

func _update_timer():
	if _round_number % 4 == 0:
		_current_init_timer_sec -= _timer_reduce_delta_sec

func _generate_next_attacks():
	var attacks_num = 2 if _round_number % 4 == 0 else 1
	_next_attacks.resize(attacks_num)
	for i in range(attacks_num):
		var random_index: int = randi() % _all_directions.size()
		var random_direction: Field.AttackDirection = Field.AttackDirection.get(_all_directions[random_index])
		_next_attacks[i] = random_direction

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

func _restart_timer():
	_timer_value_label.text = str(_current_init_timer_sec)
	_timer.wait_time = _current_init_timer_sec
	_timer.start()

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

func _finish_round():
	_por_anim_player.play(porcupine_brrr_anim_name)
	_cat_anim_player.play(cat_brrr_anim_name)
	_can_move = false
	_timer.stop()
	_thorns_remaining = _current_thorns_num
	await get_tree().create_timer(before_attack_pause_sec).timeout
	for attack in _next_attacks:
		var anim_name = str(Field.AttackDirection.keys()[attack]).to_lower()
		_big_paw_anim_player.play(anim_name)
		await _field.attack_on_salami(attack)
	_next_round()

func _close_ad():
	_ad.hide()
	_new_game()

func _take_thorn():
	_current_thorns_num -= 1
	_thorns_value_label.text = str(_current_thorns_num)
	if _current_thorns_num == 0:
		_finish_round()

func _return_thorn():
	_current_thorns_num += 1
	_thorns_value_label.text = str(_current_thorns_num)

func _back_to_menu():
	get_tree().change_scene_to_file(menu_scene_name)

func _open_rules():
	get_tree().change_scene_to_file(rules_scene_name)

func _process_timer_timeout():
	_finish_round()

func _localization(key: String):
	return LocalManager.localization.get(key)

func _on_rules_button_pressed():
	_open_rules()

func _on_timer_timeout():
	_process_timer_timeout()

func _on_replay_button_pressed():
	_restart_game()

func _on_next_button_pressed():
	_finish_round()

func _on_ok_button_pressed():
	_items_info.hide()
	_new_game()

func _on_play_button_pressed():
	if _menu.visible:
		_menu.hide()
	if _round_number > 0:
		_restart_game()
	else:
		_new_game()

func _on_menu_button_pressed():
	_back_to_menu()

func _on_how_to_play_button_pressed():
	_open_rules()
