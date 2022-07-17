extends Node2D

const number_of_ingredients = 4
const number_of_categories = 3

var level = 1
var difficulty = 1
var score = 0
var mouse_has_child = false
var item_container = null

var people_patience = 90
var people_patience_max = 90
var active_ticket = null

const Ingredients = {
	Salad = 0,
	Tomato = 1,
	Avocado = 2,
	Mushroom = 3,
	Corn = 4,
	Peas = 5,
	Pasta = 6,
	Rice = 7,
	Meat = 8,
	Cheese = 9,
	Egg = 10,
	Chicken = 11,
}

const DieTypes = {
	Vegetable = 0,
	Filler = 1,
	Meat = 2,
	Wildcard = 3
}

func add_score(s):
	score += s
	score = ceil(score)
	if score <= 0:
		score = 0
