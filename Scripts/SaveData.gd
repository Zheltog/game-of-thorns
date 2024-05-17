class_name SaveData

var record_round_quick: int = 0
var record_round_long: int = 0
var ads_enabled: bool = true
var ad_config_link: String = "https://raw.githubusercontent.com/Zheltog/game-of-thorns/main/Jsons/adconf.json"
var ad_pic_link: String = ""
var ad_click_link: String = ""
var lang: String = LocalManager.default_lang_name
var items: Dictionary = {}
var cash: int = 0

func to_dictionary() -> Dictionary:
	return {
		"record_round_quick": record_round_quick,
		"record_round_long": record_round_long,
		"ads_enabled": ads_enabled,
		"lang": lang,
		"items": items,
		"cash": cash
	}

func _init(source: Dictionary = {}):
	if source.is_empty():
		return
	var rrq = source.get("record_round_quick")
	var rrl = source.get("record_round_long")
	var ae = source.get("ads_enabled")
	var l = source.get("lang")
	var i = source.get("items")
	var c = source.get("cash")
	record_round_quick = rrq if rrq != null else record_round_quick
	record_round_long = rrl if rrl != null else record_round_long
	ads_enabled = ae if ae != null else ads_enabled
	lang = l if l != null else lang
	items = i if i != null else items
	cash = c if c != null else cash
