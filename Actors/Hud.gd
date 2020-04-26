extends Node


var score = 0


func _ready():
	$GameOver.hide()
	OS.window_size = Vector2(1024, 768)
	$Main.position = Vector2(OS.window_size.x / 2 - 32 * $Main.SIZE_HORIZONTAL / 2, 50)
	$Restart.hide()


func _process(delta):
	$FPS.set_text(str(Engine.get_frames_per_second()))


func _on_Restart_pressed():
	$GameOver.hide()
	$Restart.hide()
	$Main.restart_game()


func _on_Main_end_game():
	$GameOver.show()
	$Restart.show()


func _on_Main_food_eaten():
	score += 1
	$Score.text = "Score: " + str(score)
