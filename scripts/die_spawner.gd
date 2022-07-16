extends Node2D

var die = preload("res://objects/die.tscn")
var spawn_period = 0.3#5
var spawn_timer = 0
var spawning = true
var max_die = 5
var dices = []

func _ready():
	spawn_timer = spawn_period

func _process(delta):
	arrange_dice()
	if spawning:
		spawn_timer -= delta
		if spawn_timer <= 0:
			spawn_timer = spawn_period
			spawn()

func spawn():
	if dices.size() < max_die:
		var new_die = die.instance()
		add_child(new_die)
		new_die.global_transform.origin = global_transform.origin + Vector2(0, 1000)
		new_die.spawner = self
		dices.push_back(new_die)

func die_was_rolled(die):
	dices.erase(die)

func arrange_dice():
	for i in range(0, dices.size()):
		var d = dices[i]
		d.destination = global_transform.origin + Vector2(0, i*150)

