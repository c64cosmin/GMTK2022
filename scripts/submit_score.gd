extends Node2D

func _ready():
	$score.text = "Score: " + String(Gamestate.score)
	$TextEdit.connect("text_changed", self, "_on_text_changed")
	$submit.connect("pressed", self, "_on_submit")
	$cancel.connect("pressed", self, "_on_cancel")

func _on_text_changed():
	var text = $TextEdit.text
	if text.length() > 10:
		$TextEdit.text = text.substr(0, 10)
		$TextEdit.cursor_set_column(10)

func _on_submit():
	print($TextEdit.text)
	$submit.visible = false
	$menu.visible = true

func _on_cancel():
	$submit.visible = false
	$menu.visible = true

extends Spatial

var player_name = ""
var player_list = null
var endpoint = "https://www.stupidrat.com/hotnucleus/hi/score.php"

func _ready():
	hide_me()
	$submit.connect("pressed", self, "_on_submit_released")
	$cancel.connect("pressed", self, "_on_cancel_released")
	$HTTPRequest.connect("request_completed", self, "_on_push_completed")
	$HTTPRequest2.connect("request_completed", self, "_on_get_completed")

func get_score():
	var command = "mode=get"
	var req = endpoint + "?" + command
	$HTTPRequest2.request(req)

func submit_score(player_name, player_score):
	var command = "mode=push&name=" + player_name + "&value=" + str(int(player_score))
	var req = endpoint + "?" + command
	$HTTPRequest.request(req)

func _on_submit_released():
	submit_score(player_name, get_parent().submit_score)

func _on_cancel_released():
	get_tree().change_scene("res://scenes/hiscores.tscn")

func _on_get_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	player_list = json.result

func _on_push_completed(result, response_code, headers, body):
	get_tree().change_scene("res://scenes/hiscores.tscn")
