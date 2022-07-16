extends Node2D

var ingredient = preload("res://objects/ingredient.tscn")
var ingredients = []
var max_ingredients = 24

func _ready():
	randomize()
	pass # Replace with function body.

func _process(_delta):
	arrange_ingredients()

func add_ingredient(ingredient):
	if ingredients.find(ingredient) == -1:
		ingredients.push_back(ingredient)

func arrange_ingredients():
	for i in range(0, ingredients.size()):
		var ing = ingredients[i]
		var offset = Vector2(i*150-floor(i/12)*150*12, -floor(i/12)*150)
		ing.destination = global_transform.origin + offset

func spawn_ingredient(position, dice_type):
	if ingredients.size() < max_ingredients:
		var new_ingredient = ingredient.instance()
		get_parent().add_child(new_ingredient)
		new_ingredient.transform.origin = position
		new_ingredient.set_type(randi()%6 + dice_type*6)
		new_ingredient.bar = self
		ingredients.push_back(new_ingredient)

func remove_ingredient(ingredient):
	ingredients.erase(ingredient)
