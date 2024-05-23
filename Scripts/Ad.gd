class_name Ad

extends LocalizableCanvasLayer

static var ad_config_json_name = "res://adconf.json"
static var ad_pic_name = "res://adpic.jpg"

@onready var _pic: TextureRect = $Pic
@onready var _no_ad_rect: ColorRect = $NoAdRect

var _save_data: SaveData

func _ready():
	_save_data = SaveManager.load()
	_localize_stuff()

func update_pic():
	var image = Image.load_from_file(ad_pic_name)
	print("[Ad.update_pic] image=", image)
	var texture = ImageTexture.create_from_image(image)
	print("[Ad.update_pic] texture=", texture)
	if texture != null:
		_pic.texture = texture
		if _no_ad_rect.visible:
			_no_ad_rect.hide()
	else:
		_no_ad_rect.show()

func _on_close_button_pressed():
	EventBus.close_ad.emit()

func _on_pic_button_pressed():
	_on_ad_clicked()

func _on_ad_clicked():
	_open_url(_save_data.ad_click_link)

func _open_url(url: String):
	OS.shell_open(url)
