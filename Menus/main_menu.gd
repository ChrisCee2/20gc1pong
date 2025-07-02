class_name MainMenu extends Control

@onready var start_button: Button = $GridContainer/StartButton
@onready var exit_button: Button = $GridContainer/ExitButton

func _ready() -> void:
	start_button.pressed.connect(start_game)
	exit_button.pressed.connect(exit_game)

func start_game() -> void:
	get_tree().change_scene_to_file("res://Levels/pong.tscn")

func exit_game() -> void:
	get_tree().quit()
