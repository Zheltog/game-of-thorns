class_name Good

extends Control

@onready var _name_label: Label = $NameLabel

var good_name: String

func initialize(_name: String, _price: int):
	good_name = _name
	_name_label.text = str(_name, ":")

func _on_check_box_toggled(button_pressed):
	if button_pressed:
		EventBus.choose_good.emit(good_name)
	else:
		EventBus.unchoose_good.emit(good_name)
