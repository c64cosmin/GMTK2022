extends Node2D

var mouse_in = false

func _ready():
	$Area2D.connect("mouse_entered", self, "on_mouse_entered")
	$Area2D.connect("mouse_exited", self, "on_mouse_exited")
	$Area2D.connect("area_entered", self, "on_item_enter")

func on_mouse_entered():
	Gamestate.item_container = self
	mouse_in = true

func on_mouse_exited():
	mouse_in = false

func on_item_enter(item):
	print(item)
	if item.get_parent().is_in_group("item"):
		item.get_parent().consume()
