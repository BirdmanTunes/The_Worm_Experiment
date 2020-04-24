extends Node2D

var direction = 0
var screen_size = OS.window_size
var incrementor = 0
var list = Array()

export (PackedScene) var Tail

func _ready():
	$Timer.start()
	pass
	
	
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = 1
	if Input.is_action_pressed("ui_down"):
		direction = 2
	if Input.is_action_pressed("ui_up"):
		direction = 3


func _on_Timer_timeout():
#	incrementor += 1
#	print("###########")
#	for x in list:
#		print (x.name)
#		if (x.name == "Tail"):
#			print(str(incrementor) + "yup")
	
	var tail = Tail.instance()
	tail.position = $Head.position
	list.append(tail)
	
#	add_child_below_node($TileMap, tail)
	
	tail.connect("hit", self, "_test")
	
	
#	print(screen_size.x)
#	print(screen_size.y)
	
	if (direction == 0 and $Head.position.x > screen_size.x - 48 or
	direction == 1 and $Head.position.x < 48 or
	direction == 2 and $Head.position.y > screen_size.y - 48 or
	direction == 3 and $Head.position.y < 48):
		$Timer.stop()
		print("nope")

	else:
		if (direction == 0):
			$Head.position = Vector2($Head.position.x + 32, $Head.position.y)
		if (direction == 1):
			$Head.position = Vector2($Head.position.x - 32, $Head.position.y)
		if (direction == 2):
			$Head.position = Vector2($Head.position.x, $Head.position.y + 32)
		if (direction == 3):
			$Head.position = Vector2($Head.position.x, $Head.position.y - 32)

func _test():
	print("BODY ENTERED")
