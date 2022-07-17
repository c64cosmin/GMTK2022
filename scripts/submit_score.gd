extends Node2D

signal done
signal cancel

var wrote_a_name = false

func _ready():
	$score.text = "Score: " + String(Gamestate.score)
	$TextEdit.connect("text_changed", self, "_on_text_changed")
	$submit.connect("pressed", self, "_on_submit")
	$cancel.connect("pressed", self, "_on_cancel")
	$score_manager.connect("new_score_added", self, "_on_submmited")

func _on_text_changed():
	wrote_a_name = true
	var text = $TextEdit.text
	if text.length() > 10:
		$TextEdit.text = text.substr(0, 10)
		$TextEdit.cursor_set_column(10)

func _on_submit():
	if wrote_a_name:
		$score_manager.submit_score($TextEdit.text, Gamestate.score)
		return
	_on_cancel()

func _on_cancel():
	emit_signal("cancel")

func _on_submmited():
	emit_signal("done")
