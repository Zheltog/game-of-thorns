extends Node

signal set_thorn_request(x: int, y: int, is_strong: bool)
signal remove_thorn_request(x: int, y: int, is_strong: bool)
signal set_thorn(x: int, y: int)
signal remove_thorn(x: int, y: int)
signal no_cells_for_thorns()
signal close_ad()
signal choose_good(name: String)
signal unchoose_good(name: String)
signal open_good_info(name: String)
