class_name Pong extends Node2D

@onready var game: Game = $Game


func _process(delta: float) -> void:
	game.update()

func _physics_process(delta: float) -> void:
	game.physics_update()
