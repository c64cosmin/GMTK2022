extends "res://scripts/clickable.gd"

var type = Gamestate.Ingredients.Tomato
var time = 0
var scale_extra = 1
var scale_extra_target = 1
var destination = Vector2.ZERO
var moving_speed = 1200

func set_type(new_type):
	type = new_type
	$Sprite.frame = new_type

func _ready():
	draggable = true

func _process(delta):
	animate_shape(delta)
	move_to_destination(delta)
	inflate_on_click()

func inflate_on_click():
	if dragged:
		scale_extra_target = 1
	else:
		scale_extra_target = 0

func animate_shape(delta):
	time += delta*4
	if time > 4*PI:
		time = 0
	$Sprite.scale.x = 1 + cos(time)*0.04 + sin(time/2+0.3)*0.02
	$Sprite.scale.y = 1 + sin(time+0.5)*0.04 + cos(time/2+0.4)*0.02

func move_to_destination(delta):
	var move_direction = destination - global_transform.origin
	var move_speed = min(moving_speed, move_direction.length()/delta)
	global_transform.origin = global_transform.origin + \
	move_direction.normalized()*move_speed*delta
