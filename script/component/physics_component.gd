class_name PhysicsComponent
extends Node

@export var character_body: CharacterBody2D

@export_group("Horizontal Movement")
@export var speed: float = 300.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0

@export_group("Air Movement")
@export var air_speed: float = 150.0
@export var air_acceleration: float = 1000.0
@export var air_friction: float = 300.0

@export_group("Gravity")
@export var gravity_multiplier: float = 1.0

var direction: float = 0.0

var gravity: float:
	get:
		return ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_multiplier


func apply_gravity(delta: float) -> void:
	if character_body.is_on_floor():
		return

	character_body.velocity.y += gravity * delta


func move(delta: float, input_direction: float) -> void:
	direction = input_direction

	character_body.velocity.x = move_toward(
		character_body.velocity.x,
		input_direction * speed,
		acceleration * delta
	)


func move_in_air(delta: float, input_direction: float) -> void:
	direction = input_direction

	character_body.velocity.x = move_toward(
		character_body.velocity.x,
		input_direction * air_speed,
		air_acceleration * delta
	)


func stop(delta: float) -> void:
	direction = 0.0

	character_body.velocity.x = move_toward(
		character_body.velocity.x,
		0.0,
		friction * delta
	)


func apply_air_resistance(delta: float) -> void:
	character_body.velocity.x = move_toward(
		character_body.velocity.x,
		0.0,
		air_friction * delta
	)


func reset_velocity() -> void:
	character_body.velocity = Vector2.ZERO
