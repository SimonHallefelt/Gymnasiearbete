extends Sprite

onready var player = get_node("/root/World/MainCharacter")


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	position.x = player.position.x


func _on_Layout_position(x_led):
	position.x = 1107 + x_led






func _on_Layout_position3(xled3):
	position.x = 1107 + xled3


