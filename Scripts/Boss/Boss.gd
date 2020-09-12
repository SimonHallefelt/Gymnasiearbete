extends KinematicBody2D

signal killed
signal health_updated(health, amount)

const UP = Vector2(0, -1)
const SLOPE_STOP = 64
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var gravity = 2400
var max_gravity = 7000
var speed = 2 * (64 * 1.5)
var direction = 1
var dead = false
var entered = false
var attack_prog = false
var push_prog = false
var delay_prog = false
var max_health = 500
#var take_damage = false

onready var health = max_health setget _set_health
onready var player = get_node("/root/World/MainCharacter")
onready var anim_player = $Animations/AnimatedSprite
onready var amount = 0

func _ready():
	health = max_health
	emit_signal("health_updated", health)

func damaged(amount):
	_set_health(health - amount)

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	amount = clamp((prev_health - health), 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health, amount)
		if health <= 0:
			dead = true
			$time_to_dead.start()

func _dead():
	if health <= 0:
		dead = true
		$Body.disabled = true
		$Body2.disabled = true



func _physics_process(delta):
	if dead == false:
		if entered == true:
			if player.position.x > position.x:
				direction = 1
				velocity.x = speed
				$Attack/Attack.position.x = 169
				$push/push.position.x = 69
			if player.position.x < position.x:
				direction = -1
				velocity.x = -speed
				$Attack/Attack.position.x = -169
				$push/push.position.x = -69
			else:
				velocity.x = 0
		else:
			velocity.x = speed * direction
		
		
		velocity = move_and_slide(velocity, FLOOR)
		
		velocity.y += gravity
		if gravity > max_gravity:
			gravity = max_gravity
		
		
		if direction == -1:
			anim_player.flip_h = true
			$Attack/Attack.rotation_degrees = 217.7
			$push/push.rotation_degrees = 329.8
		else:
			anim_player.flip_h = false
			$Attack/Attack.rotation_degrees = 142.3
			$push/push.rotation_degrees = 30.2
		
		
		if is_on_wall():
			if entered == false:
				direction = direction * -1
				$Attack/Attack.position.x = $Attack/Attack.position.x * -1
				$push/push.position.x = $push/push.position.x * -1



func attack_and_push():
	if dead == false:
		if attack_prog == false:
			if push_prog == false:
				if delay_prog == false:
					if entered == true:
						if 120 > (player.position.x - position.x) and (player.position.x - position.x) > -120:
							$start_damage_push.start()
							$stop_push.start()
							speed = 0
							push_prog = true
						elif 350 > (player.position.x - position.x) and (player.position.x - position.x) > -350:
							$start_damage_attack.start()
							$stop_attack.start()
							speed = 0
							attack_prog = true



func _on_in_body_area_entered(area):
	if area.name == "Quick_Attack":
		damaged(20)
	if area.name == "Strong_Attack":
		damaged(40)


func _on_in_body_area_exited(area):
	pass

func _on_stop_take_damage_timeout():
	pass



func _on_start_damage_attack_timeout():
	$Attack/Attack.disabled = false
	$stop_damage_attack.start()

func _on_stop_damage_attack_timeout():
	$Attack/Attack.disabled = true

func _on_stop_attack_timeout():
	attack_prog = false
	$delay.start()
	delay_prog = true


func _on_start_damage_push_timeout():
	$push/push.disabled = false

func _on_stop_push_timeout():
	$push/push.disabled = true
	push_prog = false
	$delay.start()
	delay_prog = true



func _on_line_of_sight_body_entered(body):
	if dead == false:
		if body.name == "MainCharacter":
			entered = true

func _on_line_of_sight_body_exited(body):
	if body.name == "MainCharacter":
		entered = false



func _on_delay_timeout():
	delay_prog = false
	speed = 2 * (64 * 1.5)



func _on_time_to_dead_timeout():
	emit_signal("killed")

