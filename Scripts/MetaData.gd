class_name MetaData

var version: String

func _init(source: Dictionary = {}):
	if source.is_empty():
		return
	var v = source.get("version")
	version = v if v != null else v
