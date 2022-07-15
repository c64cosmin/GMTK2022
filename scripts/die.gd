extends "res://scripts/clickable.gd"

var type = Gamestate.Ingredients.Tomato
var time = 0
var being_rolled = false
var roll_timer = 0
var show_new_face = 0
var spawner = null
var destination = Vector2.ZERO
var moving_speed = 1200

func set_type(new_type):
	type = new_type
	$Sprite.frame = new_type

func _ready():
	$Sprite.frame = type

func _process(delta):
	animate_shape(delta)
	move_to_destination(delta)
	roll_the_die(delta)

func _on_clicked():
	being_rolled = true
	roll_timer = 1
	clickable = false

func move_to_destination(delta):
	var move_direction = destination - global_transform.origin
	var move_speed = min(moving_speed, move_direction.length()/delta)
	global_transform.origin = global_transform.origin + \
	move_direction.normalized()*move_speed*delta

func animate_shape(delta):
	time += delta*4
	if time > 4*PI:
		time = 0
	$Sprite.scale.x = 1 + cos(time)*0.04 + sin(time/2+0.3)*0.02
	$Sprite.scale.y = 1 + sin(time+0.5)*0.04 + cos(time/2+0.4)*0.02

func roll_the_die(delta):
	if being_rolled:
		if roll_timer > 0:
			roll_timer -= delta
			if show_new_face > 0:
				show_new_face -= delta
			if show_new_face <= 0:
				$Sprite.frame = randi()%4
				show_new_face = 0.1
		else:
			spawner.die_was_rolled(self)
			get_node("/root/game/ingredient_bar").spawn_ingredient(global_transform.origin)
			queue_free()
