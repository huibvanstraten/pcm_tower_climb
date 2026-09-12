class_name JumpComponent
extends Node

@export var character_body: CharacterBody2D

@export_group("Jump")
@export var jump_velocity: float = -400.0
@export_range(0.0, 1.0) var jump_cut_multiplier: float = 0.4

@export_group("Jump Buffer")
@export var jump_buffer_time: float = 0.12

@export_group("Coyote Time")
@export var coyote_time: float = 0.10

var jump_buffer_remaining: float = 0.0
var coyote_remaining: float = 0.0


func physics_update(delta: float, command: PlayerCommand) -> void:
	_update_jump_buffer(delta, command)
	_update_coyote_time(delta)


func jump() -> void:
	character_body.velocity.y = jump_velocity

	# The buffered jump and coyote opportunity have now been consumed.
	jump_buffer_remaining = 0.0
	coyote_remaining = 0.0


func stop_jump() -> void:
	if character_body.velocity.y < 0.0:
		character_body.velocity.y *= jump_cut_multiplier


func can_jump() -> bool:
	return (
		jump_buffer_remaining > 0.0
		and coyote_remaining > 0.0
	)


func _update_jump_buffer(delta: float, command: PlayerCommand) -> void:
	if command.jump_pressed:
		jump_buffer_remaining = jump_buffer_time
	else:
		jump_buffer_remaining = max(
			jump_buffer_remaining - delta,
			0.0
		)


func _update_coyote_time(delta: float) -> void:
	if character_body.is_on_floor():
		coyote_remaining = coyote_time
	else:
		coyote_remaining = max(
			coyote_remaining - delta,
			0.0
		)
