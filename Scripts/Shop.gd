class_name Shop

extends LocalizableCanvasLayer

static var menu_scene_name = "res://Scenes/menu.tscn"
static var goods_file_name: String = "res://Jsons/goods.json"
static var thorn_name: String = "thorn"
static var info_postfix: String = ".info"
static var logo_anim_name = "logo_anim"

@onready var _animation_player: AnimationPlayer = $BasePanel/LogoBase/AnimationPlayer
@onready var _info_panel: TextureRect = $BasePanel/InfoPanel
@onready var _info_label: Label = $BasePanel/InfoPanel/InfoLabel
@onready var _buying_components: Control = $BasePanel/BuyingComponents
@onready var _count_label: Label = $BasePanel/BuyingComponents/CountLabel
@onready var _cash_label: Label = $BasePanel/BuyingComponents/CashLabel
@onready var _zero_button: TextureButton = $BasePanel/BuyingComponents/ZeroButton
@onready var _minus_button: TextureButton = $BasePanel/BuyingComponents/MinusButton
@onready var _plus_button: TextureButton = $BasePanel/BuyingComponents/PlusButton
@onready var _buy_button: Button = $BasePanel/BuyingComponents/BuyButton
@onready var _thorn_good: Good = $BasePanel/ThornGood

var _save_data: SaveData
var _total_count: int = 0
var _extra_count: int = 0
var _total_cash: int = 0
var _current_cash: int = _total_cash
var _current_price: int
var _current_good: String
var _goods: Dictionary
var _items: Dictionary

func _ready():
	EventBus.choose_good.connect(_choose_good)
	EventBus.unchoose_good.connect(_unchoose_good)
	EventBus.open_good_info.connect(_open_good_info)
	_save_data = SaveManager.load()
	_total_cash = _save_data.cash
	_items = _save_data.items
	_goods = StorageManager.read_from(goods_file_name)
	_thorn_good.initialize(thorn_name, _goods[thorn_name])
	_info_panel.hide()
	_buying_components.hide()
	_localize_stuff()
	_animation_player.play(logo_anim_name)

func _choose_good(name: String):
	_current_good = name
	_current_price = _goods[name]
	_total_count = _items.get(name, 0)
	_extra_count = 0
	_update_cash_stuff()
	_update_count_stuff()
	_buying_components.show()

func _unchoose_good(name: String):
	_current_good = ""
	_buying_components.hide()

func _open_good_info(name: String):
	var localization_name = str(name, info_postfix)
	_info_label.text = LocalManager.localization.get(localization_name)
	_info_panel.show()

func _on_plus_button_pressed():
	if _current_cash < _current_price:
		return
	_extra_count += 1
	_update_cash_stuff()
	_update_count_stuff()

func _on_minus_button_pressed():
	if _extra_count <= 0:
		return
	_extra_count -= 1
	_update_cash_stuff()
	_update_count_stuff()

func _on_zero_button_pressed():
	_extra_count = 0
	_current_cash = _total_cash
	_update_cash_stuff()
	_update_count_stuff()

func _on_buy_button_pressed():
	_total_cash = _current_cash
	_total_count = _total_count + _extra_count
	_save_data.cash = _total_cash
	_save_data.items[_current_good] = _total_count
	SaveManager.save(_save_data)

func _on_close_button_pressed():
	_info_panel.hide()

func _on_back_button_pressed():
	get_tree().change_scene_to_file(menu_scene_name)

func _update_cash_stuff():
	_current_cash = _total_cash - _extra_count * _current_price
	_cash_label.text = str(_current_cash)

func _update_count_stuff():
	_count_label.text = str("x", _total_count + _extra_count)
	if _extra_count == 0:
		if _zero_button.visible:
			_zero_button.hide()
		if _minus_button.visible:
			_minus_button.hide()
		if _buy_button.visible:
			_buy_button.hide()
	elif _extra_count > 0:
		if not _zero_button.visible:
			_zero_button.show()
		if not _minus_button.visible:
			_minus_button.show()
		if not _buy_button.visible:
			_buy_button.show()
	if _current_cash >= _current_price:
		if not _plus_button.visible:
			_plus_button.show()
	else:
		if _plus_button.visible:
			_plus_button.hide()
