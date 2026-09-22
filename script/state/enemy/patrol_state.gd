class_name PatrolState
extends EnemyState

const NAME := "Patrol"
@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent
@export var wall_detection_left: RayCast2D
@export var wall_detection_right: RayCast2D
@export var ledge_detection_left: RayCast2D
@export var ledge_detection_right: RayCast2D

func enter() -> void:
	super()
	entity.direction = entity.initial_direction

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)
	move_component.move(delta, entity.direction)
	flip_component.update_facing(entity.direction)

	if entity.is_hit():
		return EnemyHitState.NAME

	if entity.direction > 0:
		if wall_detection_right.is_colliding() or not ledge_detection_right.is_colliding():
			entity.direction *= -1
			move_component.accute_stop()
	else:
		if wall_detection_left.is_colliding() or not ledge_detection_left.is_colliding():
			entity.direction *= -1
			move_component.accute_stop()

	return "None"
