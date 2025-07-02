class_name Game extends Node

@export var score_to_win: int = 1

@export_group("Game Objects")
@export var ball: Ball
@export var arena: Arena
@export var paddles: Node

@export_group("UI")
@export var scores: Node
@export var ui_control: Control
@export var win_label: Label
@export var return_to_menu_label: Label
@export var pause_menu: Control

var select_sfx: AudioStream = preload("res://Assets/SFX/PauseSelectSFX.wav")
var is_started = false
var game_ended = false
var is_paused = false
var initial_score: Dictionary = {"Player 1": 0, "Player 2": 0}
var score: Dictionary = initial_score.duplicate()
var win_text = "%s Wins!"
var return_to_menu_text = "[%s] to go back"

func _ready() -> void:
	pause_menu.hide()
	reset()

func update() -> void:
	if game_ended and Input.is_action_just_released("return_to_menu"):
		AudioManager.play_audio(select_sfx)
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
	
	if not game_ended and Input.is_action_just_pressed("pause"):
		pause() if not is_paused else resume()
	
	if not is_paused:
		for paddle in paddles.get_children():
			if paddle is Paddle:
				paddle.update()
	
	var potential_winner: String = get_winner()
	if potential_winner != "":
		end(potential_winner)
	
	var bound: int = arena.isOutOfBoundsX(ball.global_position, ball.getSize())
	if bound == 0:
		return
	if bound == 1:
		score["Player 1"] += 1
	elif bound == -1:
		score["Player 2"] += 1
	update_scores()
	var shouldStartLeft: bool = true if bound == -1 else false
	restart_round(shouldStartLeft)

func physics_update() -> void:
	if not is_paused:
		for paddle in paddles.get_children():
			if paddle is Paddle:
				paddle.physics_update()

func restart_round(shouldStartLeft: bool) -> void:
	ball.restart(shouldStartLeft)

func update_scores() -> void:
	for child in scores.get_children():
		if child is Control:
			var control_name = child.name
			var label = child.get_child(0)
			if label is Label:
				label.text = str(score[control_name])

func get_winner() -> String:
	for player in score:
		if score[player] >= score_to_win:
			return player
	return ""

func end(winner: String) -> void:
	ui_control.show()
	var return_to_menu_key: String = "Space"
	win_label.text = win_text % winner
	return_to_menu_label.text = return_to_menu_text % return_to_menu_key
	ball.stop()
	ball.hide()
	is_started = false
	game_ended = true

func reset() -> void:
	ui_control.hide()
	ball.start()
	ball.show()
	restart_round(randf() < 0.5)
	is_started = true
	game_ended = false
	score = initial_score.duplicate()
	update_scores()

func pause() -> void:
	AudioManager.play_audio(select_sfx)
	is_paused = true
	pause_menu.show()
	# Resume player controls
	if not game_ended:
		ball.stop()

func resume() -> void:
	AudioManager.play_audio(select_sfx)
	is_paused = false
	pause_menu.hide()
	# Resume player controls
	if not game_ended:
		ball.start()
