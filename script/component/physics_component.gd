class_name PhysicsComponent
extends Node

@export var character_body: CharacterBody2D

@export_group("Gravity")
@export var gravity_multiplier: float = 1.0

var direction: float = 0.0

var gravity: float:
	get:
		return (
			ProjectSettings.get_setting("physics/2d/default_gravity")
			* gravity_multiplier
		)


func apply_gravity(delta: float) -> void:
	if character_body.is_on_floor():
		return

	character_body.velocity.y += gravity * delta


func move_horizontal(
	delta: float,
	input_direction: float,
	speed: float,
	acceleration: float
) -> void:
	direction = input_direction

	character_body.velocity.x = move_toward(
		character_body.velocity.x,
		input_direction * speed,
		acceleration * delta
	)


func stop_horizontal(
	delta: float,
	friction: float
) -> void:
	direction = 0.0

	character_body.velocity.x = move_toward(
		character_body.velocity.x,
		0.0,
		friction * delta
	)

func halt_horiontal() -> void:
	direction = 0.0
	character_body.velocity.x = 0.0

func reset_velocity() -> void:
	character_body.velocity = Vector2.ZERO
