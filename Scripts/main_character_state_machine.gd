extends "res://Scripts/state_machine.gd"

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("attack_quick")
	add_state("attack_strong")
	add_state("take_damage")
	add_state("death")
	call_deferred("set_state", states.idle)

func _input(event):
	if [states.idle, states.walk, states.run].has(state):
		if event.is_action_pressed("jump") and parent.is_grounded:
			parent.velocity.y = parent.jump_velocity

func _state_logic(delta):
	parent.attack()
	parent._handle_move_input()
	parent._apply_gravity(delta)
	parent._apply_movement()
	parent._dead()



func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right")) != 0:
				return states.walk
			elif parent.quick_prog == 0:
				return states.attack_quick
			elif parent.strong_prog == 0:
				return states.attack_strong
			elif parent.health_change == 1:
				return states.take_damage
		states.run:
			if !parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			if !(Input.is_action_pressed("shift")) or (-int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right")) == 0):
				return states.idle
			elif parent.quick_prog == 0:
				return states.attack_quick
			elif parent.strong_prog == 0:
				return states.attack_strong
			elif parent.health_change == 1:
				return states.take_damage
		states.walk:
			if !parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right")) == 0:
				return states.idle
			elif Input.is_action_pressed("shift"):
				return states.run
			elif parent.quick_prog == 0:
				return states.attack_quick
			elif parent.strong_prog == 0:
				return states.attack_strong
			elif parent.health_change == 1:
				return states.take_damage
		states.jump:
			if parent.is_grounded:
				return states.idle
			if parent.velocity.y > 0:
				return states.fall
			if parent.health_change == 1:
				return states.take_damage
			if parent.dead == true:
				return states.death
		states.fall:
			if parent.is_grounded:
				return states.idle
			if parent.velocity.y < 0:
				return states.jump
			if parent.health_change == 1:
				return states.take_damage
			if parent.dead == true:
				return states.death
		states.attack_quick:
			if parent.quick_prog == 1:
				return states.idle
			elif parent.health_change == 1:
				return states.take_damage
		states.attack_strong:
			if parent.strong_prog == 1:
				return states.idle
			elif parent.health_change == 1:
				return states.take_damage
		states.take_damage:
			if parent.dead == true:
				return states.death
			elif parent.invis_prog == 1:
				return states.idle
		states.death:
			pass
	return null



func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.walk:
			parent.anim_player.play("walk")
		states.run:
			parent.anim_player.play("run")
		states.jump:
			parent.anim_player.play("jump")
		states.fall:
			parent.anim_player.play("fall")
		states.attack_quick:
			parent.anim_player.play("attack_quick")
		states.attack_strong:
			parent.anim_player.play("attack_strong")
		states.take_damage:
			parent.anim_player.play("take_damage")
		states.death:
			parent.anim_player.play("death")

func _exit_state(old_state, new_state):
	pass
