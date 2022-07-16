extends "res://scripts/container.gd"

var score = 0
var bonus_score = 0
var penalty = 0
var penalty_counter = 0
var patience = 0

func _ready():
	$buttonContainer/Button.connect("pressed", self, "submit_food")

func _process(delta):
	bonus_score -= delta
	patience -= delta

func on_item_enter(item):
	var ingredient = item.get_parent()
	if ingredient.is_in_group("item"):
		if ingredient.usable:
			remove_ingredient(ingredient.type)
			ingredient.consume()

func set_needed_ingredients(ingredients):
	for ingredient in $required.get_children():
		$required.remove_child(ingredient)
		ingredient.queue_free()
	for ingredient in ingredients:
		var new_ingredient = $item_template.duplicate()
		$required.add_child(new_ingredient)
		new_ingredient.frame = ingredient
		new_ingredient.visible = true
	arrange_ingredients()
	compute_score($required.get_child_count())
	patience = Gamestate.people_patience + (randi()%4)*0.3

func arrange_ingredients():
	var n = $required.get_child_count()
	var i = 0.0
	for item in $required.get_children():
		item.position.x = (i+0.5-n/2.0)*100
		i += 1

func clean_bowl():
	for item in $required.get_children():
		$required.remove_child(item)
		item.queue_free()

func remove_ingredient(type):
	for item in $required.get_children():
		if item.frame == type:
			$required.remove_child(item)
			item.queue_free()
			arrange_ingredients()
			return
	penalty += penalty_counter
	penalty_counter += 0.6

func submit_food():
	submit_score()
	Gamestate.active_ticket.queue_free()
	Gamestate.active_ticket = null
	clean_bowl()
	compute_score(0)

func compute_score(x):
	penalty = 0
	penalty_counter = 1
	score = score_curve(x)
	bonus_score = x

func score_curve(x):
	return ceil(x*x*0.4)*10

func submit_score():
	var final_score = score
	var errors = penalty + score_curve($required.get_child_count()*1.5)
	var decrease = max(0,errors*0.5 - 20)
	final_score = ceil(max(0,final_score - errors))
	Gamestate.score += final_score - decrease
	if Gamestate.score <= 0:
		Gamestate.score = 0
