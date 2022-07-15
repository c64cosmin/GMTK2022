extends "res://scripts/clickable.gd"

var type = Gamestate.Ingredients.Tomato
var time = 0

func _ready():
	$Sprite.frame = type

func _process(delta):
	time += delta*4
	if time > 4*PI:
		time = 0
	$Sprite.scale.x = 1 + cos(time)*0.04 + sin(time/2+0.3)*0.02
	$Sprite.scale.y = 1 + sin(time+0.5)*0.04 + cos(time/2+0.4)*0.02

func _on_clicked():
	print("roll the die")
