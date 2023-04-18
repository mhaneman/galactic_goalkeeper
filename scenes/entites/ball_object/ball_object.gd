extends RigidBody3D
class_name BallObject

var rng = RandomNumberGenerator.new()

const NET_POS := Vector3(6, 10, 0)
var enable_despawn_timer = true


""" callable actions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ """

func shoot(power):
	var target = Vector3()
	target.x = rng.randf_range(-NET_POS.x, NET_POS.x)
	target.y = rng.randf_range(0, NET_POS.y)
	target.z = rng.randf_range(NET_POS.z, NET_POS.z)
		

	var dir = self.global_position.direction_to(target)
	var impulse = dir * power
	self.apply_central_impulse(impulse)
	self.angular_velocity = Vector3(0, -dir.x * 50, 0)
	

func disapear():
	await get_tree().create_timer(0.2).timeout
	self.queue_free()


""" signals ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ """

func _on_despawn_timer_timeout():
	if enable_despawn_timer:
		self.queue_free()
