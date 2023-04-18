extends Node3D
class_name Kicker

var rng = RandomNumberGenerator.new()

var soccer_ball = preload("res://scenes/entites/ball_object/soccer_ball/soccer_ball.tscn")
var bomb = preload("res://scenes/entites/ball_object/bomb/bomb.tscn")

@onready var character = $character
@onready var beaming = $beaming
@onready var kick_audio = $kick_audio

var difficulty = 0

const AVE_KICK_PERIOD = 1.1
const MIN_KICK_PERIOD = 0.8
const KICK_PERIOD_RANGE = 0.2

const BOMB_PROB = 0.15
const AVE_POWER := 70.0  # was 60.0
const POWER_RANGE := 15.0
const AVE_DIST = 50

const POWER_MAX = 90

func dist_correction():
	return -self.global_position.z / AVE_DIST 
	
func rand_power():
	var ave_power = AVE_POWER * dist_correction() + difficulty * 4
	var power_low = ave_power - POWER_RANGE
	var power_high = ave_power + POWER_RANGE
	
	power_low = clampf(power_low, power_low, POWER_MAX)
	power_high = clampf(power_high, power_high, POWER_MAX)
	
	return rng.randi_range(power_low, power_high)


func rand_wait_time():
	var ave_wait = AVE_KICK_PERIOD - difficulty * 0.1
	ave_wait = clampf(ave_wait, MIN_KICK_PERIOD, ave_wait)
	
	var wait_low = ave_wait - KICK_PERIOD_RANGE
	var wait_high = ave_wait + KICK_PERIOD_RANGE
	
	return rng.randf_range(wait_low, wait_high)


func rand_bomb_prob():
	var prob = BOMB_PROB + difficulty * 0.05
	prob = clampf(prob, prob, 0.3)
	return rng.randf_range(0, 1) < prob


func _ready():
	character.play("teleport")
	$spawn_audio.play()


func despawn():
	character.visible = false
	beaming.visible = true
	beaming.play("beam-up")
	await beaming.animation_finished
	self.queue_free()


func _on_character_animation_finished():
	character.play("idle")


func _process(delta):
	kick_loop(delta)


var steps = 0
var wait_steps = 1
var counter = 0
func kick_loop(delta):
	steps += delta
	if steps >= wait_steps:
		counter += delta / 10
		steps = 0 
		
		wait_steps = rand_wait_time()
		kick_ball()


func kick_ball():
	if character.animation == "idle":
		var ball: BallObject = summon_ball()
		character.play("kick")
		kick_audio.play()
		
		var power = rand_power()
		ball.shoot(power)
	
	
func summon_ball():
	var ball
	if rand_bomb_prob():
		ball = bomb.instantiate()
	else: 
		ball = soccer_ball.instantiate()
	
	# maybe not the best way of adding children ...
	get_tree().current_scene.add_child(ball)
	
	var loc = self.global_position
	loc.z += 1
	loc.y += 0.25
	ball.global_position = loc
	return ball
