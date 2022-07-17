extends Node2D

var die = preload("res://objects/die.tscn")
var spawn_period = 1
var spawn_timer = 0
var max_die = 7
var dices = []
var pre_spawn = 5

func _ready():
	randomize()	
	spawn_timer = spawn_period

func _process(delta):
	arrange_dice()
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_timer = spawn_period
		if pre_spawn > 0:
			spawn_timer = 0.1
			pre_spawn -= 1
		spawn()

func spawn():
	if dices.size() < max_die:
		var new_die = die.instance()
		add_child(new_die)
		new_die.global_transform.origin = global_transform.origin + Vector2(0, 1000)
		new_die.spawner = self
		dices.push_back(new_die)

func die_was_rolled(die):
	$rolled.pitch_scale = 0.9 + randf()*0.4
	$rolled.play()
	dices.erase(die)

func arrange_dice():
	for i in range(0, dices.size()):
		var d = dices[i]
		d.destination = global_transform.origin + Vector2(0, i*150*Gamestate.window_scale)

