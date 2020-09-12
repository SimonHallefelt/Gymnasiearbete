extends Area2D

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "MainCharacter":
			get_tree().change_scene("res://Scenes/Levels/3/Level3.tscn")