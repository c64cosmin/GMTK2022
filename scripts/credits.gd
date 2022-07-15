extends Node2D

func _ready():
	$exit.connect("pressed", self, "_on_exit")

func _on_exit():
	get_tree().change_scene("res://scenes/main_menu.tscn")
