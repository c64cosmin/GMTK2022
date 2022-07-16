extends Node

var server = "www"
var local_server = "http://127.0.0.1:1337"
var remote_server = "https://www.stupidrat.com"
var gamename = "dicesalad"
var player_list = null
var endpoint = "www"

signal new_score_added
signal score_downloaded

func _ready():
	if OS.is_debug_build():
		server = local_server
	else:
		server = remote_server
	endpoint = server + "/" + gamename + "/hi/score.php"
	$HTTPRequest.connect("request_completed", self, "_on_push_completed")
	$HTTPRequest2.connect("request_completed", self, "_on_get_completed")

func get_score():
	var command = "mode=get"
	var req = endpoint + "?" + command
	$HTTPRequest2.request(req)

func submit_score(player_name, player_score):
	print("send : " + player_name + " " + str(player_score))
	var command = "mode=push&name=" + player_name.percent_encode() + "&value=" + str(int(player_score))
	var req = endpoint + "?" + command
	print(req)
	$HTTPRequest.request(req)

func _on_get_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	player_list = json.result
	emit_signal("score_downloaded")

func _on_push_completed(result, response_code, headers, body):
	emit_signal("new_score_added")
