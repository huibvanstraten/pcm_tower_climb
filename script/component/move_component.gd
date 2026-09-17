class_name MoveComponent
extends Node

@export var physics_component: PhysicsComponent

@export_group("Ground Movement")
@export var speed: float = 200.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0

@export_group("Air Movement")
@export var air_speed: float = 150.0
@export var air_acceleration: float = 1000.0
@export var air_friction: float = 300.0


func move(delta: float, direction: float) -> void:
	physics_component.move_horizontal(
		delta,
		direction,
		speed,
		acceleration
	)


func move_in_air(delta: float, direction: float) -> void:
	physics_component.move_horizontal(
		delta,
		direction,
		air_speed,
		air_acceleration
	)


func stop(delta: float) -> void:
	physics_component.stop_horizontal(
		delta,
		friction
	)


func apply_air_resistance(delta: float) -> void:
	physics_component.stop_horizontal(
		delta,
		air_friction
	)
