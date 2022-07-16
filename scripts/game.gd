extends Node2D

func _ready():
	Gamestate.score = 0
	for i in range(0,5):
		var new_star = $stars/star.duplicate()
		new_star.position.x += i*64
		new_star.rotation = randf()*360
		new_star.visible = true
		$stars.add_child(new_star)

func _process(delta):
	$score.text = "Score: " + String(Gamestate.score)
	Gamestate.people_patience -= delta*0.1

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_pressed("click"):
			if not OS.window_fullscreen:
				return
				OS.window_fullscreen = true
