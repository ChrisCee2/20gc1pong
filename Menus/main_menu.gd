class_name MainMenu extends Control

@onready var start_button: Button = $GridContainer/StartButton
@onready var exit_button: Button = $GridContainer/ExitButton

var select_sfx: AudioStream = preload("res://Assets/SFX/MainSelectSFX.wav")
var hover_sfx: AudioStream = preload("res://Assets/SFX/MainHoverSFX.wav")

func _ready() -> void:
	start_button.pressed.connect(start_game)
	exit_button.pressed.connect(exit_game)
	start_button.mouse_entered.connect(_on_enter)
	exit_button.mouse_entered.connect(_on_enter)

func start_game() -> void:
	AudioManager.play_audio(select_sfx)
	get_tree().change_scene_to_file("res://Levels/pong.tscn")

func exit_game() -> void:
	AudioManager.play_audio(select_sfx)
	# Some hardcoded delay so the audio finished playing
	await get_tree().create_timer(select_sfx.get_length() + 0.1).timeout
	get_tree().quit()

func return_to_main_menu() -> void:
	AudioManager.play_audio(select_sfx)
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func _on_enter() -> void:
	AudioManager.play_audio(hover_sfx)
