class_name Ad

extends ColorRect


func _ready():
	pass


func _process(delta):
	pass


func _on_close_button_pressed():
	EventBus.close_ad.emit()
