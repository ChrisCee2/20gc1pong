class_name PauseMenu extends Control

@export var game: Game

@onready var resume_button: Button = $GridContainer/ResumeButton
@onready var back_button: Button = $GridContainer/BackButton

func _ready() -> void:
	resume_button.pressed.connect(resume_game)
	back_button.pressed.connect(return_to_main_menu)

func return_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func resume_game() -> void:
	game.resume()
