class_name Root extends Node2D

@onready var ball: Ball = $Ball
@onready var arena: Arena = $Arena
@onready var paddles: Node = $Paddles

func _process(delta: float) -> void:
	var bound: int = arena.isOutOfBoundsX(ball.global_position, ball.getSize())
	if bound == 0:
		return
	var shouldStartLeft: bool = true if bound == -1 else false
	restart_round(shouldStartLeft)

func restart_round(shouldStartLeft: bool):
	ball.restart(shouldStartLeft)
