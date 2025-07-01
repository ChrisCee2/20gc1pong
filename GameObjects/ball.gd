class_name Ball extends StaticBody2D

@export var arena: Arena
@export var start_speed: float = 1.0

@onready var sprite: Sprite2D = $Sprite2D

var isActive: bool = false
var velocity: Vector2 = Vector2.ZERO


func start(shouldStartLeft: bool) -> void:
	var start_position: Vector2 = Vector2.ZERO
	if arena:
		start_position = arena.global_position
	global_position = start_position
	var angle = deg_to_rad(randf_range(20, 60))
	var x = cos(angle) * (-1 if shouldStartLeft else 1)
	var y = sin(angle) * (-1 if randf() < 0.5 else 1)
	velocity = start_speed * Vector2(x, y).normalized()
	isActive = true

func _ready() -> void:
	start(randf() < 0.5)

func _physics_process(delta: float) -> void:
	update(getDistanceFromLowerBound(), getDistanceFromUpperBound())

func update(distance_from_lower_bound: float, distance_from_upper_bound: float) -> void:
	if not isActive:
		return
	
	var curr_velocity = velocity
	if distance_from_lower_bound <= 0 || distance_from_upper_bound <= 0:
		velocity *= Vector2(1.0, -1.0)
		curr_velocity = velocity
	if velocity.y < 0:
		curr_velocity.y = min(curr_velocity.y, distance_from_upper_bound)
	elif velocity.y > 0:
		curr_velocity.y = min(curr_velocity.y, distance_from_lower_bound)
	global_position += curr_velocity

func getBounceVelocity() -> Vector2:
	return Vector2.ZERO

func getSize() -> Vector2:
	return sprite.scale

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
