class_name FallState
extends PlayerState

const NAME := "Fall"

func enter() -> void:
	super()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)
	
	if entity.command.move_direction != 0.0:
		move_component.move_in_air(delta, entity.command.move_direction)
	else:
		move_component.apply_air_resistance(delta)
	
	flip_component.update_facing(entity.command.move_direction)
	
	# to be evaluated: get reaction to hit
	var reaction := get_hit_transition()
	if reaction != "None":
		return reaction

	# TODO: refactor this...
	if jump_component.can_jump():
		return JumpState.NAME
	
	if entity.is_on_floor():
		if entity.command.move_direction:
			return MoveState.NAME

		else:
			return IdleState.NAME
	
	return "None"
