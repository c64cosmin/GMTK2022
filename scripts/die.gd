extends "res://scripts/clickable.gd"

var type = Gamestate.DieTypes.Vegetable
var time = 0
var being_rolled = false
var roll_timer = 0
var show_new_face = 0
var spawner = null
var destination = Vector2.ZERO
var moving_speed = 1200
var textures = [
	preload("res://textures/die_green.png"),
	preload("res://textures/die_blue.png"),
	preload("res://textures/die_red.png"),
	preload("res://textures/die_yellow.png")
]

func _ready():
	$slide.pitch_scale = 0.9 + randf()*0.5
	$slide.play()
	$Sprite.material = $Sprite.material.duplicate()
	$Sprite.frame = randi()%6
	if should_get_wildcard():
		set_type(Gamestate.DieTypes.Wildcard)
	else:
		if Gamestate.level == 1:
			set_type(0)
		if Gamestate.level == 2:
			if randi()%3 == 0:
				set_type(Gamestate.DieTypes.Meat)
			else:
				set_type(Gamestate.DieTypes.Vegetable)
		if Gamestate.level == 3:
			if randi()%3 == 0:
				set_type(Gamestate.DieTypes.Vegetable)
			else:
				if randi()%3 == 0:
					set_type(Gamestate.DieTypes.Filler)
				else:
					set_type(Gamestate.DieTypes.Meat)
		if Gamestate.level == 4:
			set_type(randi()%Gamestate.number_of_categories)

func set_type(new_type):
	type = new_type
	$Sprite.material.set_shader_param("material", textures[new_type])

func _process(delta):
	if being_rolled:
		if not $rolling.playing:
			$rolling.pitch_scale = 0.9 + randf()*0.4
			$rolling.play()
	animate_shape(delta)
	move_to_destination(delta)
	roll_the_die(delta)

func _on_clicked():
	being_rolled = true
	roll_timer = 1
	clickable = false

func _on_other_clicked():
	get_node("/root/game/die_spawner").spawn_timer -= 0.8
	spawn_smoke()
	queue_free()

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
		if roll_timer >= 0:
			roll_timer -= delta
			if show_new_face > 0:
				show_new_face -= delta
			if show_new_face <= 0:
				$Sprite.frame = randi()%12
				show_new_face = 0.1
		else:
			var bar = get_node("/root/game/ingredient_bar")
			if type == Gamestate.DieTypes.Wildcard:
				bar.spawn_wildcard(global_transform.origin)
			else:
				bar.spawn_ingredient_on_die(global_transform.origin, type)
			spawner.die_was_rolled(self)
			spawn_smoke()
			queue_free()

func should_get_wildcard():
	var people = get_node("/root/game/ticket_creator").tickets.size()
	if people >= 4:
		var ings = get_node("/root/game/bowl").get_ingredients_types()
		var ingsb = get_node("/root/game/ingredient_bar").get_ingredients_types()
		for ing in ingsb:
			ings.erase(ing)
		if ings.size() > 0:
			return randi()%(10 - int(people/2)) == 0
	return false

var smoke = preload("res://objects/smoke.tscn")
func spawn_smoke():
	var new_smoke = smoke.instance()
	get_node("/root/game/").add_child(new_smoke)
	new_smoke.global_transform.origin = global_transform.origin
	spawner.die_was_rolled(self)
