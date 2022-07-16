extends Node2D

var dying_star = preload("res://objects/dying_star.tscn")
var stars = 0

func _ready():
	Gamestate.score = 0
	add_stars(5)

func _process(delta):
	$score.text = "Score: " + String(Gamestate.score)
	Gamestate.people_patience -= delta*0.07

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_pressed("click"):
			if not OS.is_debug_build() and not OS.window_fullscreen:
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
	var poc_star = dying_star.instance()
	$stars.add_child(poc_star)
	poc_star.position.x = stars*64
	add_stars(stars - 1)
	if stars == 0:
		game_over()

func game_over():
	get_tree().change_scene("res://scenes/gameover.tscn")
