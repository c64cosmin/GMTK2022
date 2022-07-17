extends Node2D

var slides = [
	preload("res://textures/tutorial/tut1.jpg"),
	preload("res://textures/tutorial/tut2.jpg"),
	preload("res://textures/tutorial/tut3.jpg"),
	preload("res://textures/tutorial/tut4.jpg"),
	preload("res://textures/tutorial/tut5.jpg"),
	preload("res://textures/tutorial/tut6.jpg"),
	preload("res://textures/tutorial/tut7.jpg"),
	preload("res://textures/tutorial/tut7.5.jpg"),
	preload("res://textures/tutorial/tut8.jpg"),
	preload("res://textures/tutorial/tut9.jpg"),
	preload("res://textures/tutorial/tut10.jpg"),
	preload("res://textures/tutorial/tut11.jpg")
]
var current_slide = 0

func _ready():
	if Gamestate.had_tutorial:
		_on_skip()

	$finish.connect("pressed", self, "_on_finish")
	$skip.connect("pressed", self, "_on_skip")
	$next.connect("pressed", self, "_on_next")
	$prev.connect("pressed", self, "_on_prev")

func _process(_delta):
	$Sprite.texture = slides[current_slide]
	if current_slide == 0:
		$skip.visible = true
		$prev.visible = false
	else:
		$skip.visible = false
		$prev.visible = true
	if current_slide == slides.size()-1:
		$next.visible = false
		$finish.visible = true
	else:
		$next.visible = true
		$finish.visible = false

func _on_prev():
	current_slide -= 1
	if current_slide < 0:
		current_slide = 0

func _on_next():
	current_slide += 1
	if current_slide >= slides.size():
		current_slide = slides.size()-1

func _on_skip():
	get_tree().change_scene("res://scenes/game.tscn")

func _on_finish():
	Gamestate.had_tutorial = true
	_on_skip()
