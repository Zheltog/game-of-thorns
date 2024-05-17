extends LocalizableCanvasLayer

static var goods_file_name: String = "res://Jsons/goods.json"
static var thorn_name: String = "thorn"

var _thorn_price_label: Label
var _count_label: Label
var _current_count: int = 0
var _goods: Dictionary

func _ready():
	($BasePanel/LogoBase/AnimationPlayer).play("logo_anim")
	_thorn_price_label = get_node("BasePanel/ThornPriceLabel")
	_count_label = get_node("BasePanel/CountLabel")
	_update_count_label()
	_localize_stuff()
	_goods = StorageManager.read_from(goods_file_name)
	_thorn_price_label.text = str(_goods[thorn_name])

func _process(delta):
	pass

func _update_count_label():
	_count_label.text = str(_current_count)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_buy_button_pressed():
	print("ching-ching")

func _on_thorn_check_box_toggled(button_pressed):
	pass

func _on_zero_button_pressed():
	_current_count = 0
	_update_count_label()

func _on_minus_button_pressed():
	if _current_count > 0:
		_current_count -= 1
		_update_count_label()

func _on_plus_button_pressed():
	_current_count += 1
	_update_count_label()
