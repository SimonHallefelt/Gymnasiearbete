extends "res://Scripts/Boss/state_machine_Boss.gd"

func _ready():
	add_state("walk")
	add_state("attack")
	add_state("death")
	add_state("idle")
	add_state("push")
	call_deferred("set_state", states.walk)

func _state_logic(delta):
	parent.attack_and_push()
	parent._dead()



func _get_transition(delta):
	match state:
		states.idle:
			if parent.dead == true:
				return states.death
			else:
				return states.walk
		states.walk:
			if parent.dead == true:
				return states.death
			if parent.push_prog == true:
				return states.push
			if parent.attack_prog == true:
				return states.attack
		states.push:
			if parent.dead == true:
				return states.death
			if parent.push_prog == false:
				return states.walk
		states.attack:
			if parent.dead == true:
				return states.death
			if parent.attack_prog == false:
				return states.walk
		states.death:
			pass




func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.walk:
			parent.anim_player.play("walk")
		states.push:
			parent.anim_player.play("push")
		states.attack:
			parent.anim_player.play("attack")
		states.death:
			parent.anim_player.play("death")

