extends "res://scripts/container.gd"

var score = 0
var bonus_score = 0
var penalty = 0
var penalty_counter = 0
var patience = 0

func _ready():
	randomize()
	$buttonContainer/Button.connect("pressed", self, "submit_food")

func _process(delta):
	bonus_score -= delta
	patience -= delta
	$patience.visible = false
	if Gamestate.active_ticket != null:
		$patience.visible = true
		Gamestate.active_ticket.set_patience_face($patience)

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
			if $required.get_child_count() == 0:
				submit_food()
			return
	penalty += penalty_counter
	penalty_counter += 0.6
	if is_person_male():
		$male_sigh.play()
	else:
		$female_sigh.play()

func submit_food():
	submit_score()
	if Gamestate.active_ticket != null:
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
	var missed_ingredients = $required.get_child_count()
	var errors = (penalty + score_curve(missed_ingredients*1.5))*3
	if errors > 0:
		var low_score_chance = 10
		if Gamestate.active_ticket != null:
			if Gamestate.active_ticket.patience <= 40:
				low_score_chance += 10
			if Gamestate.active_ticket.patience <= 20:
				low_score_chance += 10
		low_score_chance += missed_ingredients*10
		if randi()%100 < low_score_chance:
			get_node("/root/game").remove_star()
	final_score = ceil(max(0,final_score - errors))
	Gamestate.add_score(final_score)
	if Gamestate.active_ticket != null:
		if is_person_male():
			if errors > 0:
				$male_sigh.play()
			else:
				$male_thanks.play()
		else:
			if errors > 0:
				$female_sigh.play()
			else:
				$female_thanks.play()
	$receipt.pitch_scale = randf()*0.1 + 1
	$cash.pitch_scale = randf()*0.1 + 1
	$receipt.play()
	if final_score > 0:
		$cash.play()

func is_person_male():
	if Gamestate.active_ticket == null:
		return false
	var male = true
	if Gamestate.active_ticket.person_face >= 3:
		male = false
	return male
func get_ingredients_types():
	var ings = []
	for ing in $required.get_children():
		ings.push_back(ing.frame)
	return ings
