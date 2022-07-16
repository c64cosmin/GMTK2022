extends Node2D

var ticket = preload("res://objects/ticket.tscn")

var spawn_period = 10
var spawn_timer = 30
var spawning = true
var tickets = []
var max_tickets = 8

func _process(delta):
	spawn_period -= delta*0.07
	arrange_tickets()
	if spawning:
		spawn_timer -= delta
		if spawn_timer <= 0:
			spawn_timer = spawn_period
			spawn()

func spawn():
	if tickets.size() < max_tickets:
		var new_ticket = ticket.instance()
		add_child(new_ticket)
		new_ticket.global_transform.origin = global_transform.origin
		new_ticket.spawner = self
		var patience = Gamestate.people_patience + randi()%20
		var patience_multiplier = 1 - randf()*0.6
		new_ticket.create_recipe(3+randi()%5, patience, patience_multiplier)
		tickets.push_back(new_ticket)

func arrange_tickets():
	for i in range(0, tickets.size()):
		var t = tickets[i]
		t.destination.x = global_transform.origin.x + i*150

func remove_ticket(ticket):
	tickets.erase(ticket)
