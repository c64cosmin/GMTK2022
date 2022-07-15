extends "res://scripts/clickable.gd"

var type = Gamestate.Ingredients.Tomato
var time = 0
var scale_extra = 1
var scale_extra_target = 1

func set_type(new_type):
	type = new_type
	$Sprite.frame = new_type

func _ready():
	draggable = true

func _process(delta):
	time += delta*(scale_extra*3+3)
	if time > 4*PI:
		time = 0
	scale_extra += (scale_extra_target - scale_extra)*delta
	$Sprite.scale.x = 1 + (cos(time)*2 + sin(time/2+0.3))*(0.01+scale_extra*0.02) + scale_extra*0.2
	$Sprite.scale.y = 1 + (sin(time+0.5)*2 + cos(time/2+0.4))*(0.01+scale_extra*0.02) + scale_extra*0.2
	if dragged:
		scale_extra_target = 1
	else:
		scale_extra_target = 0
