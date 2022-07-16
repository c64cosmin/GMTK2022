extends Node2D

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_pressed("click"):
			if not OS.window_fullscreen:
				return
				OS.window_fullscreen = true
