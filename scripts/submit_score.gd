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
