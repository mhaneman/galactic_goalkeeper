extends BallObject
class_name Bomb


func _on_body_entered(body):
	if body is Player:
		body.deactivate_player()
		self.queue_free()
