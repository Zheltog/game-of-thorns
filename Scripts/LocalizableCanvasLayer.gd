class_name LocalizableCanvasLayer

extends CanvasLayer

func _localize_stuff():
	var localizable = get_tree().get_nodes_in_group(LocalManager.localizable_group_name)
	for node in localizable:
		var node_class = node.get_class()
		match node_class:
			"Button":
				LocalManager.try_localize_button(node)
			"Label":
				LocalManager.try_localize_label(node)
