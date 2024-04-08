extends Control

var score = global.score
# Called when the node enters the scene tree for the first time.
func _ready():
	$score.text = str(int(score))
	pass # Replace with function body.

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://main_scene.tscn");

func _on_quit_button_pressed():
	get_tree().quit();
