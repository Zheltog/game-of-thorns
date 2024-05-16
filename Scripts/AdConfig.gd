class_name AdConfig

extends Node

var pic_link: String
var click_link: String

func _init(source: Dictionary = {}):
	if source.is_empty():
		return
	var pl = source.get("pic_link")
	var cl = source.get("click_link")
	pic_link = pl if pl != null else pic_link
	click_link = cl if cl != null else click_link
