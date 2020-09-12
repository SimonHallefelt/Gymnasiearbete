extends "res://Scripts/Bandit/state_machine_bandit.gd"

func _ready():
	add_state("walk")
	add_state("attack")
	add_state("damage")
	add_state("death")
	add_state("idel")
	call_deferred("set_state", states.walk)

func _state_logic(delta):
	parent.attack()
	parent._dead()



func _get_transition(delta):
	match state:
		states.idel:
			if parent.entered == false:
				return states.walk
			if parent.attack_prog == 0:
				return states.attack
			if parent.take_damage == 1:
				return states.damage
			if parent.dead == true:
				return states.death
		states.walk:
			if (parent.velocity.x == 0) and (parent.entered == true):
				return states.idel
			if parent.attack_prog == 0:
				return states.attack
			if parent.take_damage == 1:
				return states.damage
			if parent.dead == true:
				return states.death
		states.attack:
			if parent.attack_prog == 1:
				return states.walk
			if parent.take_damage == 1:
				return states.damage
			if parent.dead == true:
				return states.death
		states.damage:
			if parent.take_damage == 0:
				return states.walk
			if parent.dead == true:
				return states.death
		states.death:
			pass



func _enter_state(new_state, old_state):
	match new_state:
		states.idel:
			parent.anim_player.play("idel")
		states.walk:
			parent.anim_player.play("walk")
		states.attack:
			parent.anim_player.play("attack")
		states.damage:
			parent.anim_player.play("damage")
		states.death:
			parent.anim_player.play("death")
