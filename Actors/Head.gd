extends Area2D


signal hit_head
var direction

func _ready():
	z_index = 2

func update_direction(new_direction):
	direction = new_direction
	if (direction == 0):
		$Sprite.rotation_degrees = 90
	elif (direction == 1):
		$Sprite.rotation_degrees = 270
	elif (direction == 2):
		$Sprite.rotation_degrees = 180
	elif (direction == 3):
		$Sprite.rotation_degrees = 0

func _process(delta):
	update_direction(direction)


func _on_Head_body_entered(body):
	print("head script hit")
	emit_signal("hit_head")

