extends Node

var gamename = "dicesalad"
var player_list = null
var endpoint = "www"

signal new_score_added
signal score_downloaded

func _ready():
	endpoint = "https://www.stupidrat.com/" + gamename + "/hi/score.php"
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

func _on_get_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	player_list = json.result
	emit_signal("score_downloaded")

func _on_push_completed(result, response_code, headers, body):
	emit_signal("new_score_added")
