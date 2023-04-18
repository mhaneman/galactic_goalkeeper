extends Node3D



func _physics_process(_delta):
	for n in self.get_children():
		n.queue_free()
	set_physics_process(false)
