extends Node

func _ready():
	$MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/Menu_options/Play.grab_focus()
	
func _physics_process(delta):
	if $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/Menu_options/Play.is_hovered() == true:
		$MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/Menu_options/Play.grab_focus()
	if $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/Menu_options/Exit.is_hovered() == true:
		$MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/Menu_options/Exit.grab_focus()

func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/Levels/1/Level1.tscn")

func _on_Exit_pressed():
	get_tree().quit()
