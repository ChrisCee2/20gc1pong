extends StaticBody2D

@export var characterInput: CharacterInput
@onready var controller = $CharacterController

func _ready() -> void:
	if characterInput:
		controller.input = characterInput

func _process(delta):
	if controller:
		if controller.input != null:
			controller.input.update()

func _physics_process(delta: float) -> void:
	if controller:
		controller.update(delta)
