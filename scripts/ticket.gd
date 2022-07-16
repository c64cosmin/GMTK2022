extends Node2D

var paper_texture = preload("res://textures/ticket.png")
var length = 1

func set_length(l):
	length = l
	for i in range(0, l-1):
		create_paper_part(i, false)
	create_paper_part(l-1, true)

func create_paper_part(position, end):
	var new_paper = $paper_template.duplicate()
	$paper.add_child(new_paper)
	new_paper.visible = true
	new_paper.transform.origin = Vector2(0, position*256)
	if end:
		new_paper.frame = 1
	else:
		new_paper.frame = 0

func _ready():
	set_length(3)
