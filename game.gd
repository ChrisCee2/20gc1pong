class_name Game extends Node

@export var ball: Ball
@export var arena: Arena
@export var paddles: Node
@export var scores: Node
@export var win_control: Control
@export var score_to_win: int = 1

var is_started = false
var initial_score: Dictionary = {"Player 1": 0, "Player 2": 0}
var score: Dictionary = initial_score.duplicate()
var win_text = "%s Wins!
Press [%s] to Restart"

func _ready() -> void:
	reset()

func update() -> void:
	if Input.is_action_just_released("reset"):
		reset()
	
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
	win_control.show()
	var label = win_control.get_child(0)
	var reset_key: String = "R"
	if label is Label:
		label.text = win_text % [winner, reset_key]
	ball.end()
	is_started = false

func reset():
	win_control.hide()
	ball.start()
	restart_round(randf() < 0.5)
	is_started = true
	score = initial_score.duplicate()
	update_scores()
