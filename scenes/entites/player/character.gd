extends CharacterBody3D
class_name Player


@onready var player_sprites = $CollisionShape3D/AnimatedSprite3D
@onready var beaming_sprites = $CollisionShape3D/beaming

@onready var deactive_player_timer = $hit_with_bomb_timer

var active := true

""" physics ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ """

const SPEED = 20
const JUMP_POWER = 45
const GRAVITY = 5

func _physics_process(_delta):
	handle_physics()
	if active: handle_controls()
	move_and_slide()


func handle_physics():
	if not is_on_floor():
		velocity.y -= GRAVITY
		if active:
			player_sprites.play("jumping")
	else:
		# velocity.y = 0
		if active:
			player_sprites.play("idle")


func _on_joystick(pos):
	velocity.x = pos.x * SPEED * 5
	
	if pos.y > 50 and is_on_floor():
		velocity.y = JUMP_POWER
	
	
func handle_controls(): 
	if Input.is_action_pressed("left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += JUMP_POWER


""" callable actions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ """

func deactivate_player():
	active = false
	$bombed_audio.play()
	player_sprites.play("bombed")
	deactive_player_timer.start(1.2)

func spawn():
	pass
	

func despawn():
	active = false
	player_sprites.visible = false
	beaming_sprites.visible = true
	beaming_sprites.play("beamed-up")
	await beaming_sprites.animation_finished
	self.queue_free()


""" signals ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ """
func _on_hit_with_bomb_timer_timeout():
	active = true
