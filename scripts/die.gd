extends "res://scripts/clickable.gd"

var ingredient = preload("res://objects/ingredient.tscn")
var type = Gamestate.Ingredients.Tomato
var time = 0
var being_rolled = false
var roll_timer = 0
var show_new_face = 0

func _ready():
	$Sprite.frame = type

func _process(delta):
	time += delta*4
	if time > 4*PI:
		time = 0
	$Sprite.scale.x = 1 + cos(time)*0.04 + sin(time/2+0.3)*0.02
	$Sprite.scale.y = 1 + sin(time+0.5)*0.04 + cos(time/2+0.4)*0.02
	if being_rolled:
		if roll_timer > 0:
			roll_timer -= delta
			if show_new_face > 0:
				show_new_face -= delta
			if show_new_face <= 0:
				$Sprite.frame = randi()%4
				show_new_face = 0.1
		else:
			var new_ingredient = ingredient.instance()
			get_parent().add_child(new_ingredient)
			new_ingredient.transform.origin = transform.origin
			queue_free()

func _on_clicked():
	being_rolled = true
	roll_timer = 1
	clickable = false
