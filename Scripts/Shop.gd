extends LocalizableCanvasLayer

static var goods_file_name: String = "res://Jsons/goods.json"
static var thorn_name: String = "thorn"

var _thorn_price_label: Label
var _info_panel: TextureRect
var _info_label: Label
var _buying_components: Node
var _count_label: Label
var _cash_label: Label
var _current_count: int = 0
var _total_cash: int = 111
var _current_cash: int = _total_cash
var _current_price: int
var _current_good: String
var _goods: Dictionary

func _ready():
	($BasePanel/LogoBase/AnimationPlayer).play("logo_anim")
	_thorn_price_label = get_node("BasePanel/ThornPriceLabel")
	_info_panel = get_node("BasePanel/InfoPanel")
	_info_label = get_node("BasePanel/InfoPanel/InfoLabel")
	_buying_components = get_node("BasePanel/BuyingComponents")
	_count_label = get_node("BasePanel/BuyingComponents/CountLabel")
	_cash_label = get_node("BasePanel/BuyingComponents/CashLabel")
	_info_panel.hide()
	_buying_components.hide()
	_localize_stuff()
	_goods = StorageManager.read_from(goods_file_name)
	_thorn_price_label.text = str(_goods[thorn_name])

func _process(delta):
	pass

func _update_count_label():
	_count_label.text = str(_current_count)

func _update_cash_label():
	_current_cash = _total_cash - _current_count * _current_price
	_cash_label.text = str(_current_cash)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_buy_button_pressed():
	_total_cash = _current_cash

func _on_thorn_check_box_toggled(button_pressed):
	if button_pressed:
		_current_price = _goods[thorn_name]
		_current_good = thorn_name
		_on_zero_button_pressed()
		_update_cash_label()
		_buying_components.show()
	else:
		_current_good = ""
		_buying_components.hide()

func _on_zero_button_pressed():
	_current_count = 0
	_current_cash = _total_cash
	_update_count_label()
	_update_cash_label()

func _on_minus_button_pressed():
	if _current_count > 0 and _current_cash >= _current_price:
		_current_count -= 1
		_update_count_label()
		_update_cash_label()

func _on_plus_button_pressed():
	_current_count += 1
	_update_count_label()
	_update_cash_label()

func _on_thorn_info_button_pressed():
	_info_label.text = "sample text"
	_info_panel.show()

func _on_close_button_pressed():
	_info_panel.hide()
