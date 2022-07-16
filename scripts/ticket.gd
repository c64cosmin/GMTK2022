extends "res://scripts/clickable.gd"

var paper_texture = preload("res://textures/ticket.png")
var length = 1
var destination = Vector2.ZERO
var moving_speed = 1200
var spawner = null
var patience = 1
var patience_multiplier = 1
var person_face = 0

func _ready():
	person_face = randi()%5

func _process(delta):
	move_to_destination(delta)
	if mouse_in:
		destination.y = 0
	else:
		destination.y = -(length-1)*256*0.5
	$Area2D.scale.y = (length+1)
	$Area2D.position.y = $Area2D.scale.y*256*0.5/2
	patience -= 3*delta*patience_multiplier
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
	face.frame += person_face*6

func add_base(position):
	var roll = randi()%100
	if roll < 10:
		create_random_item(position, 1)
		return
	if roll < 50:
		create_random_item(position, 2)
		return
	create_random_item(position, 0)

func add_veggie(position):
	create_random_item(position, 0)

func add_toping(position):
	create_random_item(position, 1)

func add_meat(position):
	create_random_item(position, 2)

func add_extra(position):
	var roll = randi()%100
	if roll < 60:
		create_item(position, Gamestate.Ingredients.Cheese)
		return
	if roll < 80:
		create_item(position, Gamestate.Ingredients.Egg)
		return
	if roll < 90:
		create_item(position, Gamestate.Ingredients.Salad)
		return
	create_item(position, Gamestate.Ingredients.Avocado)

func level1_list():
	var l = randi()%int(min(5,Gamestate.difficulty)) + 1
	for i in range(0, l):
		add_veggie(i)

func level2_list():
	var l = randi()%int(min(4,Gamestate.difficulty)) + 1
	add_meat(0)
	for i in range(1, l):
		if randi()%7 == 0:
			add_meat(i)
		else:
			add_veggie(i)

func level3_list():
	var l = randi()%int(min(4,Gamestate.difficulty)) + 1
	add_meat(0)
	add_toping(1)
	for i in range(0, l-1):
		add_veggie(i)
	add_extra(l-1)

func level4_list():
	var l = randi()%int(min(6,Gamestate.difficulty)) + 1
	if l >= 1:
		add_base(0)
	if l >= 2:
		add_toping(1)
	if l >= 3:
		add_meat(2)
	if l >= 4:
		if randi()%2 == 0:
			add_veggie(3)
		else:
			add_extra(3)
	if l >= 5:
		add_extra(4)
	if l >= 6:
		add_extra(5)

func create_recipe_list():
	if Gamestate.level <= 1:
		level1_list()
	elif Gamestate.level <= 2:
		level2_list()
	elif Gamestate.level <= 3:
		level3_list()
	elif Gamestate.level <= 4:
		level4_list()
	
	var l = $items.get_child_count()
	set_length(ceil(l*90/128+0.5))
	patience = Gamestate.people_patience + randi()%20
	patience_multiplier = 1 - randf()*0.6

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

func create_random_item(position, category):
	var type = randi()%Gamestate.number_of_ingredients + category*Gamestate.number_of_ingredients
	create_item(position, type)

func create_item(position, type):
	var new_item = $item_template.duplicate()
	$items.add_child(new_item)
	new_item.visible = true
	new_item.transform.origin = Vector2(0, position*90)
	new_item.frame = type

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
	if randi()%3 == 0:
		get_node("/root/game").remove_star()
	if Gamestate.active_ticket == self:
		get_node("/root/game/bowl").clean_bowl()
		Gamestate.active_ticket = null
	queue_free()
