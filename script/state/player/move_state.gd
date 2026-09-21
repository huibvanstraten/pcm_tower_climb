class_name MoveState
extends PlayerState

const NAME := "Move"
@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent

func enter() -> void:
	super()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)
	move_component.move(delta, entity.command.move_direction)
	flip_component.update_facing(entity.command.move_direction)

	if entity.is_hit():
		return HitState.NAME
	elif entity.command.jump_pressed:
		return JumpState.NAME
	elif entity.command.interact_pressed:
		return ProgrammingState.NAME
	elif entity.velocity.x == 0.0:
		return IdleState.NAME
	else:
		return "None"
