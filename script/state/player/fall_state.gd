class_name FallState
extends PlayerState

const NAME := "Fall"

func enter() -> void:
	super()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)
	move_component.move_in_air(delta, entity.command.move_direction)
	flip_component.update_facing(entity.command.move_direction)

	if entity.is_hit():
		return HitState.NAME
		
	if entity.is_on_floor():
		return IdleState.NAME
	
	return "None"
