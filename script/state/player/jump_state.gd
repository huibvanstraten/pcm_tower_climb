class_name JumpState
extends PlayerState

const NAME := "Jump"

func enter() -> void:
	super()
	jump_component.jump()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)
	move_component.move_in_air(delta, entity.command.move_direction)
	flip_component.update_facing(entity.command.move_direction)

	if entity.is_hit():
		return HitState.NAME

	if entity.command.jump_released:
		jump_component.stop_jump()

	if entity.is_on_floor():
		return IdleState.NAME

	if entity.velocity.y > 0.0:
		return FallState.NAME

	return "None"
