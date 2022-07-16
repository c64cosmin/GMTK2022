extends "res://scripts/clickable.gd"

var paper_texture = preload("res://textures/ticket.png")
var length = 1
var destination = Vector2.ZERO
var moving_speed = 1200
var spawner = null
var patience = 1
var patience_multiplier = 1

func _process(delta):
	move_to_destination(delta)
	if mouse_in:
		destination.y = 0
	else:
		destination.y = -(length-1)*256*0.5
	$Area2D.scale.y = (length+1)
	$Area2D.position.y = $Area2D.scale.y*256*0.5/2
	patience -= delta*patience_multiplier
	set_patience_face($patience)
	if patience < 0:
		failed_ticket()

func set_patience_face(face):
	face.frame = 0
	if patience < 60:
		face.frame = 1
	if patience < 50:
		face.frame = 2
	if patience < 40:
		face.frame = 3
	if patience < 30:
		face.frame = 4
	if patience < 20:
		face.frame = 5
	
func create_recipe(l, p, pm):
	set_length(ceil(l*90/128+0.5))
	for i in range(0, l):
		create_item(i)
	patience = p
	patience_multiplier = pm

func set_length(l):
	length = l
	for i in range(0, l-1):
		create_paper_part(i, false)
	create_paper_part(l-1, true)
	$patience.position.y = (l+0.6) * 128

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
	var ingredients = []
	for item in $items.get_children():
		ingredients.push_back(item.frame)
	get_node("/root/game/bowl").set_needed_ingredients(ingredients)
	visible = false
	remove_ticket_from_bar()

func remove_ticket_from_bar():
	spawner.remove_ticket(self)

func failed_ticket():
	remove_ticket_from_bar()
	if randi()%5 == 0:
		get_node("/root/game").remove_star()
	if Gamestate.active_ticket == self:
		get_node("/root/game/bowl").clean_bowl()
		Gamestate.active_ticket = null
	queue_free()
