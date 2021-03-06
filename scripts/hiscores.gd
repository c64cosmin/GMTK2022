extends Node2D

func _ready():
	$music.play()
	$exit.connect("pressed", self, "_on_exit")
	$score_manager.connect("score_downloaded", self, "_on_downloaded")
	$score_manager.get_score()

func _on_downloaded():
	var text = ""
	var count = 1
	for player in $score_manager.player_list.list:
		if player.name.length() > 0:
			text += String(count) + ". " + player.name + "  " + String(player.score) + "\n"
			count += 1
	$scores.text = text

func _on_exit():
	get_tree().change_scene("res://scenes/main_menu.tscn")

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_pressed("click"):
			if not OS.is_debug_build() and not OS.window_fullscreen:
				OS.window_fullscreen = true
