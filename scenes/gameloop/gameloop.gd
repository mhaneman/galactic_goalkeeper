extends Node3D

var rng = RandomNumberGenerator.new()
var kicker_scene = preload("res://scenes/entites/kicker/kicker.tscn")

@onready var kickers = $kickers
@onready var player = $character
@onready var progress_timer = $progress_timer

const MIN_PROGRESS_TIME := 10 
const MAX_PROGRESS_TIME := 10
const Z_RANGE = [-80, -30]
const X_RANGE = [-20, 20]

var game_progress = 0

""" callables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ """

func start():
	start_prog_timer()
	summon_kicker(Vector3(0, 0, -50))


func stop():
	for kicker in kickers.get_children():
		kicker.despawn()
	await get_tree().create_timer(0.5).timeout
	player.despawn()
	pass
	

""" signals ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ """

func _on_new_kicker_timeout():
	game_progress += 1
	start_prog_timer()
	if kickers.get_child_count() > 0:
		kickers.get_child(0).queue_free()
	var new_pos = new_kicker_pos()
	summon_kicker(new_pos)


""" helper funcs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ """

func new_kicker_pos():
	var new_pos = Vector3.ONE
	new_pos.x = rng.randf_range(X_RANGE[0], X_RANGE[1])
	new_pos.z = rng.randf_range(Z_RANGE[0], Z_RANGE[1])
	return new_pos
	

func start_prog_timer():
	progress_timer.start(
		rng.randf_range(MIN_PROGRESS_TIME, MAX_PROGRESS_TIME))
		

func summon_kicker(pos):
	var new_kicker = kicker_scene.instantiate()
	new_kicker.difficulty = game_progress
	kickers.add_child(new_kicker)
	new_kicker.global_position = pos
