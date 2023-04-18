extends Node3D
class_name Gameloop


@onready var gameloop = $gameloop

@onready var saved_label = $counter/saved
@onready var strike_sprites = $counter/strikes


func _ready():
	Gamebus.game_state.connect(_on_state)
	Gamebus.update_values.connect(_on_update_values)
	Gamebus.emit_signal("game_state", "start_game")


func _on_state(state):
	if state == "start_game":
		_start_game()
	if state == "end_game":
		_end_game()


func _start_game():
	Gamebus.num_of_saves = 0
	Gamebus.health = 0
	
	# clear the health
	for n in strike_sprites.get_children():
		n.play("filled")
	saved_label.text = "0"
		
	gameloop.start()


func _end_game():
	gameloop.stop()
	await get_tree().create_timer(1).timeout
	saved_label.text = ""
	
	var current_score = Gamebus.num_of_saves
	if PlayerStats.get_highscore() < current_score:
		PlayerStats.update_highscore(current_score)
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
	


func _on_update_values(value):
	if value == "saves":
		$saved_audio.play()
		saved_label.text = str(Gamebus.num_of_saves)
		
	if value == "health":
		$goal_audio.play()
		$effects/invert_colors.flicker()
		if Gamebus.health <= 3:
			strike_sprites.get_child(Gamebus.health-1).play("empty")
		
		if Gamebus.health >= 3:
			Gamebus.emit_signal("game_state", "end_game")
