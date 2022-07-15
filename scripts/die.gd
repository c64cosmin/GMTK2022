extends Node2D

var type = Gamestate.Ingredients.Tomato
var time = 0
var mouse_in = false
var dragged = false
var drag_offset = Vector2.ZERO
var mouse_position = Vector2.ZERO

func _ready():
	$Area2D.connect("mouse_entered", self, "on_mouse_entered")
	$Area2D.connect("mouse_exited", self, "on_mouse_exited")
	$Sprite.frame = type

func _process(delta):
	time += delta*4
	if time > 4*PI:
		time = 0
	$Sprite.scale.x = 1 + cos(time)*0.04 + sin(time/2+0.3)*0.02
	$Sprite.scale.y = 1 + sin(time+0.5)*0.04 + cos(time/2+0.4)*0.02
	if dragged:
		transform.origin = mouse_position

func on_mouse_entered():
	mouse_in = true

func on_mouse_exited():
	mouse_in = false

func _input(event):
	if event is InputEventMouseButton:
		if mouse_in and Input.is_action_pressed("click"):
			if not Gamestate.mouse_has_child:
				Gamestate.mouse_has_child = true
				dragged = true
		if Input.is_action_just_released("click"):
			Gamestate.mouse_has_child = false
			dragged = false
	elif event is InputEventMouseMotion:
	   mouse_position = event.position
