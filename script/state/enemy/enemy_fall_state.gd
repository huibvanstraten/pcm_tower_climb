class_name EnemyFallState
extends EnemyState

const NAME := "Fall"
@export var physics_component: PhysicsComponent

func enter() -> void:
	super()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)

	if entity.is_hit():
		return EnemyHitState.NAME
	elif entity.is_on_floor():
		return PatrolState.NAME

	return "None"
