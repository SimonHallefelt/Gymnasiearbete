extends Sprite

onready var player = get_node("/root/World/MainCharacter")

func _ready():
	pass 

func _physics_process(delta):
	position.x = player.position.x * 0.2



