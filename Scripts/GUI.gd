extends MarginContainer

signal health_updated(health, amount)

func _on_MainCharacter_health_updated(health, amount):
	emit_signal("health_updated", health, amount)
