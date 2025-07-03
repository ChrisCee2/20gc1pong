class_name ComputerInput extends InputInterface

@export var game: Game
@export var arena: Arena
@export var ball: Ball
@export var paddle: Paddle

var rtc_range: Array = [2, 10]
var should_set_hit_position: bool = false
var desired_hit_position: float = 0 # Where on paddle to hit the ball
var should_set_rtc_error: bool = false
var return_to_center_error: float = 0
var ball_error: float = 2 # How many pixels it is ok for the paddle to be from the ball

func update() -> void:
	if is_ball_coming() and should_set_hit_position:
		var hit_range: Array = get_hit_range()
		desired_hit_position = randf_range(hit_range[0], hit_range[1])
		should_set_hit_position = false
		print(desired_hit_position)
	
	if not is_ball_coming() and should_set_rtc_error:
		return_to_center_error = randf_range(rtc_range[0], rtc_range[1])
		should_set_rtc_error = false
	
	var target = ball.global_position.y + desired_hit_position
	var distance_from_target: float = paddle.global_position.y - target
	
	# If ball is not coming, return to center
	if not is_ball_coming():
		should_set_hit_position = true
		distance_from_target = paddle.global_position.y - arena.global_position.y
	
	if is_ball_coming():
		should_set_rtc_error = true
	
	set_direction_to_target(distance_from_target)

func set_direction_to_target(distance_from_target: int) -> void:
	var error = ball_error if is_ball_coming() else return_to_center_error
	if abs(distance_from_target) <= error:
		isPressingUp = false
		isPressingDown = false
	elif distance_from_target < 0 :
		isPressingUp = false
		isPressingDown = true
	else:
		isPressingUp = true
		isPressingDown = false

func get_hit_range() -> Array[float]:
	var paddle_height = paddle.getSize().y
	return [paddle_height/2, -paddle_height/2]

func is_ball_coming() -> bool:
	# Find side of paddle
	var is_left = true if arena.global_position.x - paddle.global_position.x >= 0 else false
	return (is_left and ball.velocity.x <= 0) or (not is_left and ball.velocity.x > 0)
