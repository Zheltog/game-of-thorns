class_name SaveData

var record_round_quick: int = 0
var record_round_long: int = 0

func to_dictionary() -> Dictionary:
	return {
		"record_round_quick": record_round_quick,
		"record_round_long": record_round_long
	}

func _init(source: Dictionary = {}):
	if not source.is_empty():
		record_round_quick = source["record_round_quick"]
		record_round_long = source["record_round_long"]
