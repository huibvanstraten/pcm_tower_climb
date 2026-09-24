class_name MoveState
extends PlayerState

const NAME := "Move"

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
	
	if entity.velocity.x == 0.0:
		return IdleState.NAME
	
	if entity.velocity.y > 0.0:
		return FallState.NAME

	# TODO: refactor this...
	if jump_component.can_jump():
		return JumpState.NAME
	
	if entity.command.interact_pressed:
		return ProgrammingState.NAME

	return "None"
