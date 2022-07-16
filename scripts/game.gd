extends Node2D

var dying_star = preload("res://objects/dying_star.tscn")
var stars = 0

func _ready():
	Gamestate.score = 0
	add_stars(5)

func debug():
	if OS.is_debug_build():
		var text = ""
		text += "level: " + str(Gamestate.level) + "\n"
		text += "difficulty: " + str(Gamestate.difficulty) + "\n"
		text += "people_patience: " + str(Gamestate.people_patience) + "\n"
		text += "spawn_period: " + str($ticket_creator.spawn_period) + "\n"
		text += "spawn_timer: " + str($ticket_creator.spawn_timer) + "\n"
		$debug.text = text
	else:
		$debug.visible = false

func _process(delta):
	debug()
	$score.text = "Score: " + String(Gamestate.score)
	Gamestate.people_patience -= delta*0.07
	Gamestate.difficulty += delta*0.1
	if Gamestate.difficulty > 20:
		Gamestate.people_patience_max -= 10
		Gamestate.people_patience = Gamestate.people_patience_max
		Gamestate.level += 1
		Gamestate.difficulty = 1
		if Gamestate.level >= 4:
			Gamestate.level = 4
		
	if $rating/stars.get_child_count() == 0 and $rating/dying_stars.get_child_count() == 0:
		game_over()

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
	$rating/dying_stars.add_child(poc_star)
	poc_star.position.x = (stars-1)*64
	poc_star.position.y = 0
	add_stars(stars - 1)

func game_over():
	get_tree().change_scene("res://scenes/gameover.tscn")
