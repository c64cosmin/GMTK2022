extends "res://scripts/container.gd"

func on_item_enter(item):
	var ingredient = item.get_parent()
	if ingredient.is_in_group("item"):
		remove_ingredient(ingredient.type)
		ingredient.consume()

func set_needed_ingredients(ingredients):
	for ingredient in $required.get_children():
		$required.remove_child(ingredient)
		ingredient.queue_free()
	for ingredient in ingredients:
		var new_ingredient = $item_template.duplicate()
		$required.add_child(new_ingredient)
		new_ingredient.frame = ingredient
		new_ingredient.visible = true
	arrange_ingredients()

func arrange_ingredients():
	var n = $required.get_child_count()
	var i = 0.0
	for item in $required.get_children():
		item.position.x = (i+0.5-n/2.0)*100
		i += 1

func remove_ingredient(type):
	for item in $required.get_children():
		if item.frame == type:
			$required.remove_child(item)
			item.queue_free()
			arrange_ingredients()
			return
