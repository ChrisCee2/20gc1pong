class_name MainMenu extends Control

@onready var singleplayer_button: Button = $GridContainer/SingleplayerButton
@onready var multiplayer_button: Button = $GridContainer/MultiplayerButton
@onready var exit_button: Button = $GridContainer/ExitButton

func _ready() -> void:
	singleplayer_button.pressed.connect(start_singleplayer)
	multiplayer_button.pressed.connect(start_multiplayer)
	exit_button.pressed.connect(exit_game)

func start_singleplayer() -> void:
	# TODO: need to fix how this loads, because it makes it impossible to go back to main menu
	var pong_scene = preload("res://Levels/pong.tscn").instantiate()
	pong_scene.is_single_player = true
	get_tree().root.add_child(pong_scene)
	get_tree().current_scene = pong_scene
	queue_free()

func start_multiplayer() -> void:
	get_tree().change_scene_to_file("res://Levels/pong.tscn")

func exit_game() -> void:
	get_tree().quit()
