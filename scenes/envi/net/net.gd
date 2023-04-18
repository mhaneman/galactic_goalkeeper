extends Node3D


func _on_goal_area_body_entered(body: BallObject):
	if not body is SoccerBall:
		return
	
	body.soccer_ball_in_goal()
	Gamebus.health += 1
	Gamebus.emit_signal("update_values", "health")


func _on_saved_back_area_body_entered(body):
	if body is SoccerBall:
		Gamebus.num_of_saves += 1
		Gamebus.emit_signal("update_values", "saves")
	body.disapear()
