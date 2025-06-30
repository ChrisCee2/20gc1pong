class_name CharacterInput extends Node

var isPressingUp = false
var isPressingDown = false

@export var upKey: String
@export var downKey: String

func update():
	isPressingUp = Input.is_action_pressed(upKey)
	isPressingDown = Input.is_action_pressed(downKey)

func getDirection() -> int:
	var direction: int = 0
	if isPressingUp:
		direction -= 1
	if isPressingDown:
		direction += 1
	return direction
