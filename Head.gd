extends Area2D


signal hit_head


func _on_Head_body_entered(body):
	print("head script hit")
	emit_signal("hit_head")
