class_name Arena extends Node2D

@onready var wall_1 = $Wall
@onready var wall_2 = $Wall1

@onready var wall_1_sprite = $Wall/Sprite2D
@onready var wall_2_sprite = $Wall1/Sprite2D

@onready var divider = $Divider

@export var arena_range_in_pixels = 200
@export var divider_width = 1

func _ready() -> void:
	wall_1.global_position = global_position - (Vector2.DOWN * arena_range_in_pixels / 2)
	wall_2.global_position = global_position + (Vector2.DOWN * arena_range_in_pixels / 2)
	divider.scale = Vector2(divider_width, arena_range_in_pixels)

func getUpperBound() -> float:
	return wall_1.global_position.y + (wall_1_sprite.scale.y / 2)

func getLowerBound() -> float:
	return wall_2.global_position.y - (wall_2_sprite.scale.y / 2)
