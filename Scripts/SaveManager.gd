class_name SaveManager

static var save_file_path: String = "user://save.data"

static func save(data: SaveData):
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	var json_string = JSON.stringify(data.to_dictionary())
	file.store_line(json_string)

static func load() -> SaveData:
	var file = FileAccess.open(save_file_path, FileAccess.READ)
	if file == null:
		return SaveData.new()
	var json_string = file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return null
	var dictionary = json.get_data()
	return SaveData.new(dictionary)
