extends KinematicBody2D

signal health_updated(health, amount)
signal health_depleted
signal killed()
signal position(x_led)

const UP = Vector2(0, -1)
const SLOPE_STOP = 64

var velocity = Vector2()
var x_led = 1
var move_speed = 4 * (64 * 1.5)
var run_speed = 6 * (64 * 1.5)
var gravity = 2400
var max_gravity = 10000
var jump_velocity = -1000
var is_grounded
var velocity2 = Vector2()
var quick_prog = 1
var strong_prog = 1
var invis_prog = 0
var health_change = 0
var max_health = 100
var dead = false

onready var health = max_health setget _set_health
onready var amount = 0
onready var anim_player = $Body/AnimatedSprite
onready var invulnerability_timer = $InvlunerabilityTimer
onready var quick = $QuickAttack
onready var damage_quick = $Time_to_QuickAttack
onready var strong = $StrongAttack
onready var damage_strong = $Time_to_StrongAttack
onready var time_to_dead = $Time_to_dead

onready var teleport_to = get_node("/root/World/Portal_ut")
onready var teleport_to2 = get_node("/root/World/Portal_ut2")
onready var teleport_to3 = get_node("/root/World/Portal_ut3")
onready var teleport_to4 = get_node("/root/World/Portal_ut4")
onready var teleport_to5 = get_node("/root/World/Portal_ut5")
onready var teleport_to6 = get_node("/root/World/Portal_ut6")
onready var teleport_to7 = get_node("/root/World/Portal_ut7")
onready var teleport_to8 = get_node("/root/World/Portal_ut8")
onready var teleport_to9 = get_node("/root/World/Portal_ut9")
onready var teleport_to10 = get_node("/root/World/Portal_ut10")
onready var teleport_to11 = get_node("/root/World/Portal_ut11")

func _position_cloud():
	if x_led < position.x:
		x_led = position.x
		emit_signal("position", x_led)
	emit_signal("position", x_led)
	if x_led > position.x:
		x_led = position.x
		emit_signal("position", x_led)

func _ready():
	health = max_health
	emit_signal("health_updated", health)
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _apply_gravity(delta):
	velocity.y += gravity * delta
	if gravity >= max_gravity:
		gravity = max_gravity

func _apply_movement():
	velocity = move_and_slide(velocity, UP, SLOPE_STOP)
	velocity2 = move_and_slide(velocity2, UP, SLOPE_STOP)
	is_grounded = _check_is_grounded()

func _handle_move_input():
	if dead == false:
		if !(Input.is_action_pressed("shift")):
			var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
			velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
			if strong_prog == 1 and quick_prog == 1:
				if move_direction != 0:
					$Body.scale.x = move_direction
		if Input.is_action_pressed("shift"):
			var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
			velocity.x = lerp(velocity.x, run_speed * move_direction, _get_h_weight())
			if strong_prog == 1 and quick_prog == 1:
				if move_direction != 0:
					$Body.scale.x = move_direction
		if !(Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left")):
			if Input.is_action_pressed("move_right"):
				if strong_prog == 1 and quick_prog == 1:
					$Quick_Attack/CollisionShape2D.position.x = 54
					$Strong_Attack/CollisionShape2D.position.x = 9
					$Strong_Attack/CollisionShape2D3.position.x = 85
			if Input.is_action_pressed("move_left"):
				if strong_prog == 1 and quick_prog == 1:
					$Quick_Attack/CollisionShape2D.position.x = -54
					$Strong_Attack/CollisionShape2D.position.x = -9
					$Strong_Attack/CollisionShape2D3.position.x = -85

func _get_h_weight():
	return 0.2 if is_grounded else 0.1

func _check_is_grounded():
	for raycasts in $Raycasts.get_children():
		if raycasts.is_colliding():
			return true
	return false

func damaged(amount):
	if invulnerability_timer.is_stopped():
		invis_prog = 0
		invulnerability_timer.start()
		_set_health(health - amount)

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	amount = clamp((prev_health - health), 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health, amount)
		if health <= 0:
			time_to_dead.start()

func _dead():
	if health == 0:
		dead = true
		move_speed = 0
		run_speed = 0

func attack():
	if Input.is_action_just_pressed("attack_quick"):
		if strong.is_stopped():
			if quick.is_stopped():
				quick_prog = 0
				damage_quick.start()
				quick.start()
				move_speed = 0
				run_speed = 0
	if Input.is_action_just_pressed("attack_strong"):
		if quick.is_stopped():
			if strong.is_stopped():
				strong_prog = 0
				damage_strong.start()
				strong.start()
				move_speed = 0
				run_speed = 0

func _on_InvlunerabilityTimer_timeout():
	invis_prog = 1

func _on_QuickAttack_timeout():
	$Quick_Attack/CollisionShape2D.disabled = true
	quick_prog = 1
	move_speed = 4 * (64 * 1.5)
	run_speed = 6 * (64 * 1.5)

func _on_Time_to_QuickAttack_timeout():
	if health_change == 0:
		if quick_prog == 0:
			if velocity.y == 0:
				$Quick_Attack/CollisionShape2D.disabled = false

func _on_StrongAttack_timeout():
	$Strong_Attack/CollisionShape2D.disabled = true
	$Strong_Attack/CollisionShape2D3.disabled = true
	strong_prog = 1
	move_speed = 4 * (64 * 1.5)
	run_speed = 6 * (64 * 1.5)

func _on_Time_to_StrongAttack_timeout():
	if health_change == 0:
		if strong_prog == 0:
			if velocity.y == 0:
				$Strong_Attack/CollisionShape2D.disabled = false
				$Strong_Attack/CollisionShape2D3.disabled = false

func _on_Area2D_area_entered(area):
	if area.name == "Bandit_Damage":
		damaged(25)
		print(health)
		health_change = 1
		strong_prog = 1
		quick_prog = 1
		move_speed = 4 * (64 * 1.5)
		run_speed = 6 * (64 * 1.5)
	if area.name == "Attack":
		damaged(60)
		print(health)
		health_change = 1
		strong_prog = 1
		quick_prog = 1
		move_speed = 4 * (64 * 1.5)
		run_speed = 6 * (64 * 1.5)
	if area.name == "push":
		damaged(15)
		print(health)
		health_change = 1
		strong_prog = 1
		quick_prog = 1
		move_speed = 4 * (64 * 1.5)
		run_speed = 6 * (64 * 1.5)
	if dead == false:
		if  area.name == "Portal":
			position = teleport_to.position
		if  area.name == "Portal2":
			position = teleport_to2.position
		if  area.name == "Portal3":
			position = teleport_to3.position
		if  area.name == "Portal4":
			position = teleport_to4.position
		if  area.name == "Portal5":
			position = teleport_to5.position
		if  area.name == "Portal6":
			position = teleport_to6.position
		if  area.name == "Portal7":
			position = teleport_to7.position
		if  area.name == "Portal8":
			position = teleport_to8.position
		if  area.name == "Portal9":
			position = teleport_to9.position
		if  area.name == "Portal10":
			position = teleport_to10.position
		if  area.name == "Portal11":
			position = teleport_to11.position

func _on_Area2D_area_exited(area):
	if area.name == "Bandit_Damage" or area.name == "Attack" or area.name == "push":
		health_change = 0

func _on_Time_to_dead_timeout():
	emit_signal("killed")
