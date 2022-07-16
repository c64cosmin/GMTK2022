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
			var offset = Vector2(i*150-floor(i/12)*150*12, -floor(i/12)*150)
			ing.destination = global_transform.origin + offset

func spawn_ingredient(position, dice_type):
	if has_empty_space():
		var new_ingredient = ingredient.instance()
		get_parent().add_child(new_ingredient)
		new_ingredient.transform.origin = position
		new_ingredient.set_type(randi()%Gamestate.number_of_ingredients + dice_type*Gamestate.number_of_ingredients)
		new_ingredient.bar = self
		add_ingredient(new_ingredient)

func remove_ingredient(ingredient):
	for i in range(0, max_ingredients):
		if ingredients[i] == ingredient:
			ingredients[i] = null
