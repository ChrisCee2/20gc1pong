class_name Paddle extends StaticBody2D

@export var characterInput: CharacterInput
@export var arena: Arena
@onready var controller = $CharacterController

@onready var sprite = $Sprite2D

func _ready() -> void:
	if characterInput:
		controller.input = characterInput

func _process(delta):
	if controller and arena:
		if controller.input != null:
			controller.input.update()

func _physics_process(delta: float) -> void:
	if controller:
		controller.update(getDistanceFromLowerBound(), getDistanceFromUpperBound())

func getSize() -> Vector2:
	return sprite.scale

func getDistanceFromUpperBound() -> float:
	var paddleSize: Vector2 = getSize()
	return (global_position.y - (paddleSize.y / 2)) - arena.getUpperBound()

func getDistanceFromLowerBound() -> float:
	var paddleSize: Vector2 = getSize()
	return arena.getLowerBound() - (global_position.y + (paddleSize.y / 2))
