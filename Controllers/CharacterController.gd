class_name CharacterController extends Node

@export var input: CharacterInput
@export var object: StaticBody2D
@export var velocity = 2

func update(delta):
	if not input:
		return
	var y: int = input.getDirection()
	object.global_position += Vector2(0, y)
