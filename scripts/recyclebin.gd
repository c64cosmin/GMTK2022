extends "res://scripts/container.gd"

func on_mouse_entered():
	.on_mouse_entered()
	Gamestate.item_container = self

func on_item_enter(item):
	if item.get_parent().is_in_group("item"):
		item.get_parent().consume()
		$trash.play()
		$crumble.pitch_scale = 0.8 + randf()*0.4
		$crumble.play()
