extends Node2D

var score = 0
var mouse_has_child = false
var item_container = null

var people_patience = 90
var active_ticket = null

const Ingredients = {
	Tomato = 0,
	Avocado = 1,
	Egg = 2,
	Salad = 3
}

const DieTypes = {
	Vegetable = 0,
	Meat = 1,
	Fruit = 2,
	Seasoning = 3
}

func add_score(s):
	score += s
	score = ceil(score)
	if score <= 0:
		score = 0
