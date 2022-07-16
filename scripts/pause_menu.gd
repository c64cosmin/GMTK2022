extends Node2D

func _ready():
	$retry.connect("pressed", self, "_on_retry")
	$exit.connect("pressed", self, "_on_exit")
	pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	if Input.is_action_just_pressed("exit"):
		visible = !visible
		get_tree().paused = visible

func _on_retry():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/game.tscn")

func _on_exit():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/main_menu.tscn")
