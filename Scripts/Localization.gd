extends Node

var map: Dictionary

func _ready():
	# todo: test
	map = {
		"MenuButton" : "меню",
		"PlayButton": "играть",
		"NextButton": "всё",
		"ReplayButton": "ещё",
		"NextAttacksNameLabel": "аттаки",
		"TimerNameLabel": "тик-так",
		"RoundNameLabel": "раунд",
		"ThornsNameLabel": "шипов"
	}

func try_localize_button(button: Button, text_postfix: String = ""):
	var localization = get_for(button)
	if localization != null:
		button.text = localization + text_postfix

func try_localize_label(label: Label, text_postfix: String = ""):
	var localization = get_for(label)
	if localization != null:
		label.text = localization + text_postfix

func get_for(node: Node) -> String:
	return map.get(node.name)
