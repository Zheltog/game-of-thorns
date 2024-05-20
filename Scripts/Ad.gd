class_name Ad

extends ColorRect

static var ad_config_json_name = "adconf.json"
static var ad_pic_name = "adpic.jpg"

@onready var _pic: TextureRect = $Pic

var _save_data: SaveData

func _ready():
	_save_data = SaveManager.load()

func update_pic():
	var image = Image.load_from_file(str("res://", ad_pic_name))
	var texture = ImageTexture.create_from_image(image)
	_pic.texture = texture

func _on_close_button_pressed():
	EventBus.close_ad.emit()

func _on_pic_button_pressed():
	_on_ad_clicked()

func _on_ad_clicked():
	_open_url(_save_data.ad_click_link)

func _open_url(url: String):
	OS.shell_open(url)
