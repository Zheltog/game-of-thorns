class_name SaveManager

static var save_file_name = "user://save.data"

static func save(data: SaveData):
	StorageManager.write_to(save_file_name, data.to_dictionary())

static func load() -> SaveData:
	var dictionary = StorageManager.read_from(save_file_name)
	return SaveData.new(dictionary)
