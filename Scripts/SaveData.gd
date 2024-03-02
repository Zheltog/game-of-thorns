class_name SaveData

var record_round_quick: int = 0
var record_round_long: int = 0
var ads_enabled: bool = true
var lang: String

func to_dictionary() -> Dictionary:
	return {
		"record_round_quick": record_round_quick,
		"record_round_long": record_round_long,
		"ads_enabled": ads_enabled,
		"lang": lang
	}

func _init(source: Dictionary = {}):
	if source.is_empty():
		return
	var rrq = source.get("record_round_quick")
	var rrl = source.get("record_round_long")
	var ae = source.get("ads_enabled")
	var l = source.get("lang")
	record_round_quick = rrq if rrq != null else record_round_quick
	record_round_long = rrl if rrl != null else record_round_long
	ads_enabled = ae if ae != null else ads_enabled
	lang = l if l != null else lang
