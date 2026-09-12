class_name FlipComponent
extends Node

@export var animated_sprite: AnimatedSprite2D
@export var flip_marker: Node2D

var facing_direction: int = 1


func update_facing(input_direction: float) -> void:
	if input_direction == 0.0:
		return

	var new_direction := int(sign(input_direction))

	if new_direction == facing_direction:
		return

	facing_direction = new_direction
	_apply_flip()


func _apply_flip() -> void:
	var facing_left := facing_direction < 0

	if animated_sprite != null:
		animated_sprite.flip_h = facing_left

	if flip_marker != null:
		flip_marker.scale.x = facing_direction
