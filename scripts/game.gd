extends Node2D

func _ready():
	Gamestate.score = 0

func _process(delta):
	$score.text = "Score: " + String(Gamestate.score)
	Gamestate.people_patience -= delta*0.1

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_pressed("click"):
			if not OS.window_fullscreen:
				return
				OS.window_fullscreen = true
