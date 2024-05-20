class_name Good

extends Control

static var name_postfix = ".name"

@onready var _name_label: Label = $NameLabel
@onready var _price_label: Label = $PriceLabel

var good_name: String

func initialize(_name: String, _price: int):
	good_name = _name
	var localized_name = LocalManager.localization.get(str(_name, name_postfix))
	_name_label.text = str(localized_name, ":")
	_price_label.text = str(_price)

func _on_check_box_toggled(button_pressed):
	if button_pressed:
		EventBus.choose_good.emit(good_name)
	else:
		EventBus.unchoose_good.emit(good_name)

func _on_info_button_pressed():
	EventBus.open_good_info.emit(good_name)
