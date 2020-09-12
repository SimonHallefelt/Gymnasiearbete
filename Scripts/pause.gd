extends Control

var dead = false

func _ready():
	$CenterContainer/VBoxContainer/Close.grab_focus()

func _physics_process(delta):
	if $CenterContainer/VBoxContainer/Close.is_hovered() == true:
		$CenterContainer/VBoxContainer/Close.grab_focus()
	if $CenterContainer/VBoxContainer/Restart.is_hovered() == true:
		$CenterContainer/VBoxContainer/Restart.grab_focus()
	if $CenterContainer/VBoxContainer/Main_menu.is_hovered() == true:
		$CenterContainer/VBoxContainer/Main_menu.grab_focus()

func _input(event):
	if dead == false:
		if event.is_action_pressed("Pause"):
			$CenterContainer/VBoxContainer/Close.grab_focus()
			get_tree().paused = not get_tree().paused
			visible = not visible

func _on_Close_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible

func _on_Restart_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible
	get_tree().change_scene("res://Scenes/Levels/1/Level1.tscn")

func _on_Main_menu_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible
	get_tree().change_scene("res://Scenes/General/MainMenu.tscn")

func _on_MainCharacter_killed():
	dead = true
