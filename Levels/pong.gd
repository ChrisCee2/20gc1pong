class_name Pong extends Node2D

@onready var game: Game = $Game


func _process(delta: float) -> void:
	game.update()
