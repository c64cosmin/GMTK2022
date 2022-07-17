extends Node2D

var ingredient = preload("res://objects/ingredient.tscn")
var ingredients = []
var max_ingredients = 24

func _ready():
	for i in range(0,max_ingredients):
		ingredients.push_back(null)
	randomize()
	pass # Replace with function body.

func _process(_delta):
	arrange_ingredients()

func has_empty_space():
	for i in range(0, max_ingredients):
		if ingredients[i] == null:
			return true
	return false

func add_ingredient(ingredient):
	for i in range(0, max_ingredients):
		if ingredients[i] == null:
			ingredients[i] = ingredient
			return

func arrange_ingredients():
	for i in range(0, ingredients.size()):
		var ing = ingredients[i]
		if ing != null:
			var offset = Vector2((i%12)*145, -floor(i/12)*150)*Gamestate.window_scale
			ing.destination = global_transform.origin + offset

func spawn_ingredient_on_die(position, dice_type):
	var ing_type = randi()%Gamestate.number_of_ingredients + dice_type*Gamestate.number_of_ingredients
	spawn_ingredient(position, ing_type)

func spawn_ingredient(position, ing_type):
	if has_empty_space():
		var new_ingredient = ingredient.instance()
		get_parent().add_child(new_ingredient)
		new_ingredient.global_transform.origin = position
		new_ingredient.set_type(ing_type)
		new_ingredient.bar = self
		add_ingredient(new_ingredient)

func find_missing_ingredient(ings):
	var types = [0, 1, 2, 3]
	var meats = false
	var topping = false
	for ing in ingredients:
		if ing != null:
			if ing.type >= 4 and ing.type < 8 and topping == false:
				topping = true
				for i in range(4, 8):
					types.push_back(i)
			if ing.type >= 8 and ing.type < 12 and meats == false:
				meats = true
				for i in range(8, 12):
					types.push_back(i)
			types.erase(ing.type)
	if types.size() == 0:
		return randi()%(int(min(3,Gamestate.level))*4)
	return types[randi()%types.size()]

func spawn_wildcard(position):
	var ings = []
	if Gamestate.active_ticket != null:
		ings = get_node("/root/game/bowl").get_ingredients_types()
		spawn_ingredient(position, ings[randi()%ings.size()])
	else:
		ings = get_ingredients_types()
		spawn_ingredient(position, find_missing_ingredient(ings))
	
func remove_ingredient(ingredient):
	for i in range(0, max_ingredients):
		if ingredients[i] == ingredient:
			ingredients[i] = null

func get_ingredients_types():
	var ings = []
	for ing in ingredients:
		if ing != null:
			ings.push_back(ing.type)
	return ings
