class_name Paddle extends StaticBody2D

@export var isLeft: bool
@export var characterInput: CharacterInput
@export var arena: Arena
@export_range(1, 89) var maxBounceAngle: float = 70
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

func getBounceAngle(bouncePosition: Vector2) -> float:
	var distanceFromCenter = global_position - bouncePosition
	if distanceFromCenter.y == 0:
		return 0
	# Flipping sign because negative y is up
	return -(maxBounceAngle * (distanceFromCenter.y / (getSize().y / 2)))
