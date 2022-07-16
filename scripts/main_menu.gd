extends Node2D

func _ready():
	$start.connect("pressed", self, "_on_start")
	$credits.connect("pressed", self, "_on_credits")
	$hiscore.connect("pressed", self, "_on_hi_score")
	$gameover.connect("pressed", self, "_on_gameover")

func _on_start():
	get_tree().change_scene("res://scenes/game.tscn")

func _on_credits():
	get_tree().change_scene("res://scenes/credits.tscn")

func _on_hi_score():
	print("show hi score")

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_pressed("click"):
			if not OS.is_debug_build() and not OS.window_fullscreen:
				OS.window_fullscreen = true

func _on_gameover():
	Gamestate.score = 1234 + randi()%1000
	get_tree().change_scene("res://scenes/gameover.tscn")
