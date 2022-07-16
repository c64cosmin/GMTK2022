extends "res://scripts/container.gd"

func on_mouse_entered():
	.on_mouse_entered()
	Gamestate.item_container = self

func on_item_enter(item):
	if item.get_parent().is_in_group("item"):
		item.get_parent().consume()
