extends LocalizableCanvasLayer

func _ready():
	($BasePanel/LogoBase/AnimationPlayer).play("logo_anim")
	_localize_stuff()

func _on_back_button_pressed():
	_back()

func _back():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
