class_name MainMenu extends Control

@onready var start_button: Button = $GridContainer/StartButton
@onready var exit_button: Button = $GridContainer/ExitButton

var select_sfx: AudioStream = preload("res://Assets/SFX/SelectSFX.wav")

func _ready() -> void:
	start_button.pressed.connect(start_game)
	exit_button.pressed.connect(exit_game)

func start_game() -> void:
	AudioManager.play_audio(select_sfx)
	get_tree().change_scene_to_file("res://Levels/pong.tscn")

func exit_game() -> void:
	AudioManager.play_audio(select_sfx)
	# Some hardcoded delay so the audio finished playing
	await get_tree().create_timer(select_sfx.get_length() + 0.1).timeout
	get_tree().quit()
