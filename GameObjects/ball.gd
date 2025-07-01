class_name Ball extends StaticBody2D

@export var paddles: Node
@export var arena: Arena
@export var start_speed: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D

var isActive: bool = false
var current_speed: float = start_speed
var velocity: Vector2 = Vector2.ZERO
var paddlesBeingCollidedWith: Array[Paddle] = []

func restart(shouldStartLeft: bool) -> void:
	paddlesBeingCollidedWith = []
	var start_position: Vector2 = Vector2.ZERO
	if arena:
		start_position = arena.global_position
	global_position = start_position
	var angle = deg_to_rad(randf_range(20, 60))
	var x = cos(angle) * (-1 if shouldStartLeft else 1)
	var y = sin(angle) * (-1 if randf() < 0.5 else 1)
	velocity = start_speed * Vector2(x, y).normalized()
	isActive = true
	current_speed = start_speed

func _ready() -> void:
	restart(randf() < 0.5)

func _physics_process(delta: float) -> void:
	physics_update(getDistanceFromLowerBound(), getDistanceFromUpperBound())

func physics_update(distance_from_lower_bound: float, distance_from_upper_bound: float) -> void:
	if not isActive:
		return
	
	# Paddle bounce logic
	handlePaddleBounce()
	
	var curr_velocity = velocity
	
	# Wall bounce logic
	if distance_from_lower_bound <= 0 || distance_from_upper_bound <= 0:
		velocity *= Vector2(1.0, -1.0)
		velocity = velocity.normalized() * current_speed
		curr_velocity = velocity
	if velocity.y < 0:
		var y = min(abs(curr_velocity.y), distance_from_upper_bound)
		var factor = abs(curr_velocity.y) / y
		curr_velocity /= factor
		curr_velocity.y = -y
	elif velocity.y > 0:
		var y = min(curr_velocity.y, distance_from_lower_bound)
		var factor = abs(curr_velocity.y) / y
		curr_velocity /= factor
		curr_velocity.y = y
	global_position += curr_velocity

func getBounceVelocity() -> Vector2:
	return Vector2.ZERO

func getSize() -> Vector2:
	return sprite.scale

func isBallOverlappingPaddle(paddle: Paddle) -> bool:
	return paddle.global_position.x + (paddle.getSize().x / 2) >= global_position.x - (getSize().x / 2) && \
	paddle.global_position.x - (paddle.getSize().x / 2) <= global_position.x + (getSize().x / 2) && \
	paddle.global_position.y + (paddle.getSize().y / 2) >= global_position.y - (getSize().y / 2) && \
	paddle.global_position.y - (paddle.getSize().y / 2) <= global_position.y + (getSize().y / 2)

func handlePaddleBounce() -> void:
	var collidingPaddles: Array[Paddle] = []
	for paddle in paddles.get_children():
		if paddle is Paddle and isBallOverlappingPaddle(paddle):
			collidingPaddles.append(paddle)
			if paddle not in paddlesBeingCollidedWith:
				var direction_x = 1 if velocity.x < 0 else -1
				var angle = deg_to_rad(paddle.getBounceAngle(global_position))
				var x = cos(angle)
				var y = sin(angle)
				velocity = Vector2(direction_x * x, y) * start_speed
	paddlesBeingCollidedWith = collidingPaddles

func getDistanceFromUpperBound() -> float:
	if not arena:
		return 10000
	var paddleSize: Vector2 = getSize()
	return (global_position.y - (paddleSize.y / 2)) - arena.getUpperBound()

func getDistanceFromLowerBound() -> float:
	if not arena:
		return 10000
	var paddleSize: Vector2 = getSize()
	return arena.getLowerBound() - (global_position.y + (paddleSize.y / 2))
