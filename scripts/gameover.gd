extends Node2D

func _ready():
	$menu/retry.connect("pressed", self, "_on_retry")
	$menu/exit.connect("pressed", self, "_on_exit")

func _on_retry():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/game.tscn")

func _on_exit():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/main_menu.tscn")
