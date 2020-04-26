extends Node2D

var direction = 0
var list = Array()
var food_storage
var previous_pos
var spawn_food = false
var spawn_loc_ok = false
var spawn_tail = false
var head_pos
var SIZE_VERTICAL = 15
var SIZE_HORIZONTAL = 20

signal end_game
signal food_eaten


export (PackedScene) var Tail
export (PackedScene) var Food

func restart_game():
	food_storage.queue_free()
	var x = randi()%SIZE_VERTICAL+1
	var y = randi()%SIZE_HORIZONTAL+1
	_spawn_food(x, y)
	direction = 0
	$Head.update_direction(direction)
	$Head.position = Vector2(16,16)
	for x in list:
		if x.name != "Head":
			x.queue_free()
#			x.remove_and_skip()
	list = Array()
	list.append($Head)
	
	previous_pos = null
	$Timer.start()


func _ready():
	randomize()
	generate_map()
	list.append($Head)
	$Head.update_direction(direction)
	
	$Timer.start()
	var x = randi()%SIZE_HORIZONTAL+1
	var y = randi()%SIZE_VERTICAL+1
	_spawn_food(x, y)


func _process(delta):
	
	if (spawn_food):
		var x = randi()%SIZE_HORIZONTAL+1
		var y = randi()%SIZE_VERTICAL+1
		spawn_loc_ok = true
		var rand_pos = Vector2( -16 + x * 32,-16 + y *32)
		if (rand_pos == $Head.position):
			spawn_loc_ok = false
		for x in list:
			if (x.position == rand_pos):
				spawn_loc_ok = false
		if (spawn_loc_ok):
			_spawn_food(x, y)
			spawn_loc_ok = false
			spawn_food = false
	if Input.is_action_pressed("ui_right") and direction != 1:
		direction = 0
		$Head.update_direction(direction)
	elif Input.is_action_pressed("ui_left") and direction != 0:
		direction = 1
		$Head.update_direction(direction)
	elif Input.is_action_pressed("ui_down") and direction != 3:
		direction = 2
		$Head.update_direction(direction)
	elif Input.is_action_pressed("ui_up") and direction != 2:
		direction = 3
		$Head.update_direction(direction)
		


func _spawn_food(x, y):
	
	var food = Food.instance()
	food.position = Vector2( -16 + x * 32,-16 + y *32)
	food.connect("hamham", self, "_on_Food_hamham")
	food.z_index = 1
	food_storage = food
	call_deferred("add_child", food)
	var food2 = Food.instance()


func generate_map():
	for x in range(0, SIZE_HORIZONTAL):
		for y in range (0, SIZE_VERTICAL):
			$TileMap.set_cell(x, y, 0)

func _on_Timer_timeout():
	
	if (spawn_tail):
		var tail = Tail.instance()
		tail.z_index = 1
		tail.connect("hit_tail", self, "tail_hit")
		list.append(tail)
		call_deferred("add_child", tail)
		spawn_tail = false
	
	previous_pos = null
	var list_dup = list.duplicate()
	list_dup.invert()
	
	for x in list_dup:
		if (previous_pos != null):
			previous_pos.position = x.position
		previous_pos = x
	
	if (direction == 0 and $Head.position.x > SIZE_HORIZONTAL * 32 - 48 or
		direction == 1 and $Head.position.x < 48 or
		direction == 2 and $Head.position.y > SIZE_VERTICAL * 32 - 48 or
		direction == 3 and $Head.position.y < 48):
		emit_signal("end_game")
		$GameOver.play()
		$Timer.stop()
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


func _on_Food_hamham():
	emit_signal("food_eaten")
	$AppleCrunch.play()
	spawn_food = true
	spawn_tail = true
	head_pos = $Head.position
	
func tail_hit():
	$GameOver.play()
	$Timer.stop()
	emit_signal("end_game")
	print("HIT")
