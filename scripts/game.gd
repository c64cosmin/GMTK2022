extends Node2D

var stars = 0

func _ready():
	Gamestate.score = 0
	add_stars(5)

func _process(delta):
	$score.text = "Score: " + String(Gamestate.score)
	Gamestate.people_patience -= delta*0.1

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_pressed("click"):
			if not OS.window_fullscreen:
				return
				OS.window_fullscreen = true

func add_stars(n):
	stars = n
	for star in $rating/stars.get_children():
		star.remove_child(star)
		star.queue_free()
	for i in range(0,n):
		var new_star = $rating/star_template.duplicate()
		new_star.position.x += i*64
		new_star.rotation = randf()*360
		new_star.visible = true
		$rating/stars.add_child(new_star)

func remove_star():
	add_stars(stars - 1)
