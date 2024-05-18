extends LocalizableCanvasLayer

static var goods_file_name: String = "res://Jsons/goods.json"
static var thorn_name: String = "thorn"
static var info_postfix: String = ".info"

var _save_data: SaveData
var _thorn_price_label: Label
var _info_panel: TextureRect
var _info_label: Label
var _buying_components: Node
var _count_label: Label
var _cash_label: Label
var _zero_button: TextureButton
var _minus_button: TextureButton
var _plus_button: TextureButton
var _buy_button: Button
var _total_count: int = 0
var _extra_count: int = 0
var _total_cash: int = 0
var _current_cash: int = _total_cash
var _current_price: int
var _current_good: String
var _goods: Dictionary
var _items: Dictionary

func _ready():
	($BasePanel/LogoBase/AnimationPlayer).play("logo_anim")
	_save_data = SaveManager.load()
	_total_cash = _save_data.cash
	_items = _save_data.items
	print(_items)
	_goods = StorageManager.read_from(goods_file_name)
	_thorn_price_label = get_node("BasePanel/ThornPriceLabel")
	_thorn_price_label.text = str(_goods[thorn_name])
	_info_panel = get_node("BasePanel/InfoPanel")
	_info_panel.hide()
	_info_label = get_node("BasePanel/InfoPanel/InfoLabel")
	_buying_components = get_node("BasePanel/BuyingComponents")
	_buying_components.hide()
	_count_label = get_node("BasePanel/BuyingComponents/CountLabel")
	_cash_label = get_node("BasePanel/BuyingComponents/CashLabel")
	_zero_button = get_node("BasePanel/BuyingComponents/ZeroButton")
	_minus_button = get_node("BasePanel/BuyingComponents/MinusButton")
	_plus_button = get_node("BasePanel/BuyingComponents/PlusButton")
	_buy_button = get_node("BasePanel/BuyingComponents/BuyButton")
	_localize_stuff()

func _process(delta):
	pass

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

func _update_cash_stuff():
	_current_cash = _total_cash - _extra_count * _current_price
	_cash_label.text = str(_current_cash)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_buy_button_pressed():
	_total_cash = _current_cash
	_total_count = _total_count + _extra_count
	_save_data.cash = _total_cash
	_save_data.items[_current_good] = _total_count
	SaveManager.save(_save_data)

func _on_thorn_check_box_toggled(button_pressed):
	if button_pressed:
		_current_price = _goods[thorn_name]
		_total_count = _items.get(thorn_name, 0)
		_extra_count = 0
		_current_good = thorn_name
		_update_cash_stuff()
		_update_count_stuff()
		_buying_components.show()
	else:
		_current_good = ""
		_buying_components.hide()

func _on_zero_button_pressed():
	_extra_count = 0
	_current_cash = _total_cash
	_update_cash_stuff()
	_update_count_stuff()

func _on_minus_button_pressed():
	if _extra_count > 0:
		_extra_count -= 1
		_update_cash_stuff()
		_update_count_stuff()

func _on_plus_button_pressed():
	if _current_cash >= _current_price:
		_extra_count += 1
		_update_cash_stuff()
		_update_count_stuff()

func _on_thorn_info_button_pressed():
	var localization_name = str(thorn_name, info_postfix)
	_info_label.text = LocalManager.localization.get(localization_name)
	_info_panel.show()

func _on_close_button_pressed():
	_info_panel.hide()
