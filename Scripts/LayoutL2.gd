extends Node

signal position(x_led)
signal position2(xled2)
signal position3(xled3)

var s = 5
var xled3 = 100
onready var player = get_node("/root/World/MainCharacter")
onready var xled2 = player.position.x


func _ready():
	print(5)
	emit_signal("position3", xled3)
	print(xled2)
	pass # Replace with function body.

func _where_is_player3():
	if xled3 < player.position.x:
		emit_signal("position3", xled3)
		print(8)
	if xled3 > player.position.x:
		emit_signal("position3", xled3)
		print(8)
	if s < xled3:
		print(9)
	if (Input.is_action_pressed("move_left")):
		print(10)
	if(Input.is_action_pressed("move_right")):
		print(11)


func _where_is_player(value):
	emit_signal("position2", xled2)
	print(7)

func _on_MainCharacter_position(x_led):
	emit_signal("position", x_led)
	print(6)
