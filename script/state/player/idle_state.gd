class_name IdleState
extends PlayerState

const NAME := "Idle"

func enter() -> void:
	super()
	physics_component.halt_horizontal()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)

	if entity.is_hit():
		return HitState.NAME

	if entity.velocity.y > 0.0:
		return FallState.NAME

	if entity.command.move_direction != 0.0:
		return MoveState.NAME

	if entity.command.jump_pressed:
		return JumpState.NAME

	if entity.command.interact_pressed:
		return ProgrammingState.NAME

	return "None"
