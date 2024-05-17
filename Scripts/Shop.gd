extends LocalizableCanvasLayer

func _ready():
	($BasePanel/LogoBase/AnimationPlayer).play("logo_anim")
	_localize_stuff()

func _process(delta):
	pass

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
