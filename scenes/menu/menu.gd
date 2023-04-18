extends Node

@onready var high_score_val = $info/stats/high_score/value
@onready var last_score_val = $info/stats/last_score/value

@onready var last_score_panel = $info/stats/last_score
@onready var high_score_panel = $info/stats/high_score


const GAME_PATH = "res://scenes/game/game.tscn"

@onready var craft = $background/craft
@onready var beam = $background/craft/beam
@onready var beam_audio = $background/craft/beam_audio

func _ready():
	beam.visible = false
	
	if Gamebus.num_of_saves >= 0:
		last_score_panel.visible = false
		high_score_panel.visible = false
		
		beam.visible = true
		beam.play("beamed-up")
		beam_audio.play()
		craft.play("empty")
		await beam.animation_finished
		beam.visible = false
		craft.play("idle")
		
		await get_tree().create_timer(0.5).timeout
		last_score_val.text = str(Gamebus.num_of_saves)
		last_score_panel.visible = true
		
		
		await get_tree().create_timer(0.75).timeout
		high_score_val.text = str(PlayerStats.get_highscore())
		high_score_panel.visible = true
		
	elif PlayerStats.get_highscore() > 0:
		craft.play("idle")
		last_score_panel.visible = false
		high_score_panel.visible = true
		high_score_val.text = str(PlayerStats.get_highscore())
		
	else:
		craft.play("idle")
		last_score_panel.visible = false
		high_score_panel.visible = false
		


var time = 0
func _process(delta):
	time += delta
	craft.position.y = 0.1 * sin(3 * time)
	

func _on_start_button_pressed():
	beam.visible = true
	beam.play("beamed-down")
	craft.play("empty")
	beam_audio.play()
	await beam.animation_finished
	get_tree().change_scene_to_file(GAME_PATH)
