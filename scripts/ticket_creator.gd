extends Node2D

var ticket = preload("res://objects/ticket.tscn")

var spawn_period = 0.1#5
var spawn_timer = 0
var spawning = true
var tickets = []
var max_tickets = 8

func _process(delta):
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
		tickets.push_back(new_ticket)

func arrange_tickets():
	for i in range(0, tickets.size()):
		var t = tickets[i]
		t.destination.x = global_transform.origin.x + i*150

func remove_ticket(ticket):
	tickets.erase(ticket)
