extends "res://scripts/clickable.gd"

var paper_texture = preload("res://textures/ticket.png")
var length = 1
var destination = Vector2.ZERO
var moving_speed = 1200
var spawner = null

func _ready():
	create_recipe(3+randi()%5)

func _process(delta):
	move_to_destination(delta)
	if mouse_in:
		destination.y = 0
	else:
		destination.y = -(length-1)*256*0.5
	$Area2D.scale.y = length
	$Area2D.position.y = length*256*0.5/2

func create_recipe(l):
	set_length(ceil(l*90/128+0.5))
	for i in range(0, l):
		create_item(i)

func set_length(l):
	length = l
	for i in range(0, l-1):
		create_paper_part(i, false)
	create_paper_part(l-1, true)

func create_paper_part(position, end):
	var new_paper = $paper/paper_template.duplicate()
	$paper.add_child(new_paper)
	new_paper.visible = true
	new_paper.transform.origin = Vector2(0, position*256)
	if end:
		new_paper.frame = 1
	else:
		new_paper.frame = 0

func create_item(position):
	var new_item = $item_template.duplicate()
	$items.add_child(new_item)
	new_item.visible = true
	new_item.transform.origin = Vector2(0, position*90)
	new_item.frame = randi()%4

func move_to_destination(delta):
	var move_direction = destination - global_transform.origin
	var move_speed = min(moving_speed, move_direction.length()/delta)
	global_transform.origin = global_transform.origin + \
	move_direction.normalized()*move_speed*delta

func _on_clicked():
	if Gamestate.active_ticket != null:
		return
	Gamestate.active_ticket = self
	spawner.remove_ticket(self)
	var ingredients = []
	for item in $items.get_children():
		ingredients.push_back(item.frame)
	get_node("/root/game/bowl").set_needed_ingredients(ingredients)
	self.visible = false
