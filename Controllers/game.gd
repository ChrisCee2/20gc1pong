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

var is_started = false
var game_ended = false
var initial_score: Dictionary = {"Player 1": 0, "Player 2": 0}
var score: Dictionary = initial_score.duplicate()
var win_text = "%s Wins!"
var return_to_menu_text = "[%s] to main menu"

func _ready() -> void:
	reset()

func update() -> void:
	if game_ended and Input.is_action_just_released("return_to_menu"):
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
	
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

func restart_round(shouldStartLeft: bool):
	ball.restart(shouldStartLeft)

func update_scores():
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

func end(winner: String):
	ui_control.show()
	var return_to_menu_key: String = "Space"
	win_label.text = win_text % winner
	return_to_menu_label.text = return_to_menu_text % return_to_menu_key
	ball.end()
	is_started = false
	game_ended = true

func reset():
	ui_control.hide()
	ball.start()
	restart_round(randf() < 0.5)
	is_started = true
	game_ended = false
	score = initial_score.duplicate()
	update_scores()
