extends "res://scripts/clickable.gd"

var type = Gamestate.Ingredients.Tomato
var usable = false
var time = 0
var scale_extra = 1
var scale_extra_target = 1
var destination = Vector2.ZERO
var moving_speed = 1200
var bar = null

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

func _on_clicked():
	usable = true
	bar.remove_ingredient(self)

func _on_other_clicked():
	print("it happens")
	bar.remove_ingredient(self)
	destination = get_node("/root/game/recyclebin").global_transform.origin

func _on_released():
	bar.add_ingredient(self)
	
	return
	var container = Gamestate.item_container
	if container.mouse_in:
		container.on_dropped_item(self)

func consume():
	bar.remove_ingredient(self)
	queue_free()
	spawn_smoke()

var smoke = preload("res://objects/smoke.tscn")
func spawn_smoke():
	var new_smoke = smoke.instance()
	get_node("/root/game/").add_child(new_smoke)
	new_smoke.global_transform.origin = global_transform.origin
