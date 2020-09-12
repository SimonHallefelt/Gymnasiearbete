extends KinematicBody2D

const UP = Vector2(0, -1)
const SLOPE_STOP = 64
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var gravity = 2400
var max_gravity = 7000
var speed = 5 * (64 * 1.5)
var direction = 1
var dead = false
var entered = false
var attack_prog = 1
var delay_prog = 1
var max_health = 100
var take_damage = 0

onready var health = max_health setget _set_health
onready var player = get_node("/root/World/MainCharacter")
onready var anim_player = $body/AnimatedSprite
onready var attack = $Attack
onready var delay = $Delay
onready var time_to_damage = $Damage

func _ready():
	health = max_health

func damaged(amount):
	_set_health(health - amount)

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		if health <= 0:
			dead = true

func _dead():
	if health <= 0:
		dead = true
		$PhysicsShape.disabled = true
		$PhysicsShape2.disabled = true
		$Bandit_Damage/CollisionShape2D.disabled = true
		$Bandit_Damage/CollisionShape2D2.disabled = true

func _physics_process(delta):
	if dead == false:
		if entered == true:
			if $Raycasts/RayCast2D.is_colliding() == true:
				if player.position.x < position.x - 0:
					velocity.x = -speed
					direction = -1
					$Raycasts/RayCast2D.position.x = -55
					$Area2D/CollisionShape2D.position.x = -233
					$Area2D/CollisionShape2D2.position.x = 140
					$Bandit_Damage/CollisionShape2D.position.x = -30
					$Bandit_Damage/CollisionShape2D2.position.x = -76
				elif player.position.x > position.x + 0:
					velocity.x = speed
					direction = 1
					$Raycasts/RayCast2D.position.x = 55
					$Area2D/CollisionShape2D.position.x = 233
					$Area2D/CollisionShape2D2.position.x = -140
					$Bandit_Damage/CollisionShape2D.position.x = 30
					$Bandit_Damage/CollisionShape2D2.position.x = 76
				else:
					velocity.x = 0
			else:
				velocity.x = 0
		else:
			velocity.x = speed * direction
		
		velocity = move_and_slide(velocity, FLOOR)
		
		velocity.y += gravity
		if gravity > max_gravity:
			gravity = max_gravity
		
		if direction == -1:
			$body/AnimatedSprite.flip_h = true
		else:
			$body/AnimatedSprite.flip_h = false
		
		if $Raycasts/RayCast2D.is_colliding() == false:
			if entered == false:
				direction = direction * -1
				$Raycasts/RayCast2D.position.x = $Raycasts/RayCast2D.position.x * -1
				$Area2D/CollisionShape2D.position.x = $Area2D/CollisionShape2D.position.x * -1
				$Area2D/CollisionShape2D2.position.x = $Area2D/CollisionShape2D2.position.x * -1
				$Bandit_Damage/CollisionShape2D.position.x = $Bandit_Damage/CollisionShape2D.position.x * -1
				$Bandit_Damage/CollisionShape2D2.position.x = $Bandit_Damage/CollisionShape2D2.position.x * -1
		elif is_on_wall():
			if entered == false:
				direction = direction * -1
				$Raycasts/RayCast2D.position.x = $Raycasts/RayCast2D.position.x * -1
				$Area2D/CollisionShape2D.position.x = $Area2D/CollisionShape2D.position.x * -1
				$Area2D/CollisionShape2D2.position.x = $Area2D/CollisionShape2D2.position.x * -1
				$Bandit_Damage/CollisionShape2D.position.x = $Bandit_Damage/CollisionShape2D.position.x * -1
				$Bandit_Damage/CollisionShape2D2.position.x = $Bandit_Damage/CollisionShape2D2.position.x * -1

func attack():
	if dead == false:
		if attack_prog == 1:
			if delay_prog == 1:
				if entered == true:
					if take_damage == 0:
						if 125 > (player.position.x - position.x) and (player.position.x - position.x) > -125:
							if attack.is_stopped():
								attack_prog = 0
								delay_prog = 0
								attack.start()
								time_to_damage.start()

func _on_Area2D_body_entered(body):
	if dead == false:
		if body.name == "MainCharacter":
			entered = true

func _on_Area2D_body_exited(body):
	if body.name == "MainCharacter":
		entered = false

func _on_Attack_timeout():
	attack_prog = 1
	$Bandit_Damage/CollisionShape2D.disabled = true
	$Bandit_Damage/CollisionShape2D2.disabled = true
	delay.start()

func _on_Delay_timeout():
	delay_prog = 1

func _on_Damage_timeout():
	if dead == false:
		if attack_prog == 0:
			if take_damage == 0:
				$Bandit_Damage/CollisionShape2D.disabled = false
				$Bandit_Damage/CollisionShape2D2.disabled = false

func _on_Take_Damage_area_entered(area):
	if area.name == "Quick_Attack":
		damaged(40)
		take_damage = 1
		attack_prog = 1
	if area.name == "Strong_Attack":
		damaged(80)
		take_damage = 1
		attack_prog = 1

func _on_Take_Damage_area_exited(area):
	if area.name == "Quick_Attack":
		take_damage = 0
	if area.name == "Strong_Attack":
		take_damage = 0
