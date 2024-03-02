extends Node

static var meta_file_name: String = "res://Jsons/meta.json"

var meta_data: MetaData

func _ready():
	var dictionary = StorageManager.read_from(meta_file_name)
	meta_data = MetaData.new(dictionary)
