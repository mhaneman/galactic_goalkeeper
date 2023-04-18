extends Node
class_name SaveGame

const SAVE_GAME_PATH = "user://player_data.save"

func _ready():
	init_user_data()


var default_data = {
	"highscore": -1,
}

var current_data = {}


func update_highscore(value) -> void:
	current_data["highscore"] = value
	save_data()
	
func get_highscore() -> int:
	return current_data["highscore"]
	
	
func init_user_data():
	if not FileAccess.file_exists(SAVE_GAME_PATH):
		current_data = default_data.duplicate(true)
		save_data()
	
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	var json_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	current_data = json_data
	
	
func save_data():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	var json_string = JSON.stringify(current_data)
	file.store_line(json_string)
	file.close()
	
	
func reset_data():
	current_data.clear()
	current_data = default_data.duplicate(true)
	
	
	
	
