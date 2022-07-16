extends Node2D

var draggable = false
var clickable = true

var mouse_in = false
var dragged = false
var mouse_position = Vector2.ZERO

func _ready():
	$Area2D.connect("mouse_entered", self, "on_mouse_entered")
	$Area2D.connect("mouse_exited", self, "on_mouse_exited")

func _process(delta):
	if dragged and draggable:
		global_transform.origin = mouse_position

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
				if clickable:
					_on_clicked()
		if Input.is_action_just_released("click"):
			Gamestate.mouse_has_child = false
			dragged = false
			if clickable:
				_on_released()
	elif event is InputEventMouseMotion:
	   mouse_position = event.position

func _on_clicked():
	pass

func _on_released():
	pass
