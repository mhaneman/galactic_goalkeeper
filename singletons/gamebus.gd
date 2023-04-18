extends Node

signal game_state(state)
signal update_values()

var num_of_saves = -1
var health = 0

func _ready():
	self.game_state.connect(_on_state)
	
func _on_state(state):
	if state == "start_game":
		pass
	if state == "end_game":
		pass

