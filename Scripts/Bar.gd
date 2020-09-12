extends HBoxContainer

signal pulse()

const FLASH_RATE = 0.05
const N_FLASHES = 4

onready var health_over = $Gauge2nd/Gauge
onready var health_under = $Gauge2nd
onready var update_tween = $UpdateTween
onready var pulse_tween = $PulseTween
onready var flash_tween = $FlashTween
onready var flash_timer = $FlashTimer

var max_health = 100

export (Color) var healthy_color = Color.green
export (Color) var caution_color = Color.yellow
export (Color) var danger_color = Color.crimson
export (Color) var pulse_color = Color.darkred
export (Color) var flash_color = Color.gray
export (float) var healthy_zone = 0.75
export (float) var caution_zone = 0.5
export (float) var danger_zone = 0.25

func _ready():
	health_over.value = 100
	health_over.tint_progress = healthy_color
	health_under.value = 100

func _on_GUI_health_updated(health, amount):
	update_tween.interpolate_property(health_under, "value", health_under.value, health, 0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
	update_tween.start()
	health_over.value = health
	
	_assign_color(health)

	if amount > 0:
		_flash_damage()

	if health <= max_health * danger_zone:
		pulse_tween.interpolate_property(health_over, "tint_progress", danger_color, pulse_color, 0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
		pulse_tween.interpolate_callback(self, 0.0, "emit_signal", "pulse")
		pulse_tween.start()

func _flash_damage():
	for i in range(N_FLASHES * 2):
		var color = health_over.tint_progress if i % 2 == 1 else flash_color
		var time = FLASH_RATE * i + FLASH_RATE
		flash_tween.interpolate_callback(health_over, time, "set", "tint_progress", color)
	flash_tween.start()

func _assign_color(health):
	if health == 0:
		pulse_tween.set_active(false)
	elif health <= health_over.max_value * danger_zone:
		health_over.tint_progress = danger_color
	elif health <= health_over.max_value * caution_zone:
		health_over.tint_progress = caution_color
	elif health >= health_over.max_value * healthy_zone:
		health_over.tint_progress = healthy_color