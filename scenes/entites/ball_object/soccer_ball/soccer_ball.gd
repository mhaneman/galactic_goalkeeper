extends BallObject
class_name SoccerBall

@onready var soccer_ball_mesh = $CollisionShape3D/soccer_ball


func _physics_process(_delta):
	if self.linear_velocity.z < 0:
		Gamebus.num_of_saves += 1
		Gamebus.emit_signal("update_values", "saves")
		self.disapear()
		set_physics_process(false)
	
	
func soccer_ball_in_goal():
	self.linear_velocity = self.linear_velocity.limit_length(10)
