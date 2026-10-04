class_name PhysicsComponent
extends Node

@export var character_body: CharacterBody2D

@export_group("Gravity")
@export var gravity_multiplier: float = 1.0

var direction: float = 0.0
var fall_speed: float = 0.0

var gravity: float:
	get:
		return (
			ProjectSettings.get_setting("physics/2d/default_gravity")
			* gravity_multiplier
		)


func apply_gravity(delta: float) -> void:
	if character_body.is_on_floor():
		fall_speed = 0.0
		return

	character_body.velocity.y += gravity * delta

	if character_body.velocity.y > 0.0:
		fall_speed = character_body.velocity.y
	else:
		fall_speed = 0.0
		

func get_fall_speed() -> float:
	return fall_speed

	
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

func halt_horizontal() -> void:
	direction = 0.0
	character_body.velocity.x = 0.0

func reset_velocity() -> void:
	character_body.velocity = Vector2.ZERO


func apply_knockback(
	direction: Vector2,
	knockback: Vector2
) -> void:
	character_body.velocity.x = direction.x * knockback.x
	character_body.velocity.y = -knockback.y
