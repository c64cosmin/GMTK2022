extends Node2D

var ticket = preload("res://objects/ticket.tscn")

var spawn_period = 10
var spawn_timer = 20
var spawning = true
var tickets = []
var max_tickets = 8

func _ready():
	print("moinciun")
	randomize()

func _process(delta):
	arrange_tickets()
	if spawning:
		spawn_timer -= delta
		if spawn_timer <= 0:
			spawn_timer = spawn_period
			if randi()%3 == 0:
				spawn_timer /= 2
			spawn_period -= 0.4
			if spawn_period < 1:
				spawn_period = 7
			if randi()%10 == 0:
				spawn_period += 1
				if spawn_period > 10:
					spawn_period = 10
			spawn()
			if randi() % 5 == 0:
				spawn()
				if randi() % 3 == 0:
					spawn()

func spawn():
	if tickets.size() < max_tickets:
		var new_ticket = ticket.instance()
		add_child(new_ticket)
		new_ticket.global_transform.origin = global_transform.origin
		new_ticket.spawner = self
		new_ticket.create_recipe_list()
		tickets.push_back(new_ticket)
		$new_client.pitch_scale = 1.3 + randf()*0.3
		$new_client.play()

func arrange_tickets():
	for i in range(0, tickets.size()):
		var t = tickets[i]
		t.destination.x = global_transform.origin.x + i*150*Gamestate.window_scale

func remove_ticket(ticket):
	tickets.erase(ticket)
