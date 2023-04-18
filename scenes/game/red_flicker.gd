extends ColorRect

func _ready():
	self.material.set_shader_parameter("hide", true)

func flicker():
	self.material.set_shader_parameter("hide", false)
	await get_tree().create_timer(0.2).timeout
	self.material.set_shader_parameter("hide", true)
