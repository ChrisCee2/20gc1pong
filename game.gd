class_name Game extends Node

@export var ball: Ball
@export var arena: Arena
@export var paddles: Node
@export var scores: Node

var is_started = false
var score: Dictionary = {"Player1": 0, "Player2": 0}

func _ready() -> void:
	is_started = true
	update_scores()

func update() -> void:
	var bound: int = arena.isOutOfBoundsX(ball.global_position, ball.getSize())
	if bound == 0:
		return
	if bound == 1:
		score["Player1"] += 1
	elif bound == -1:
		score["Player2"] += 1
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
