class_name FallState
extends PlayerState

func enter():
	super()
	print("FALL STATE")


func physics_update(
	delta: float,
	command: PlayerCommand
) -> PlayerTransition.Type:
	player.physics_component.apply_gravity(delta)
	
	if command.move_direction != 0.0:
		player.move_component.move_in_air(
			delta,
			command.move_direction
		)
	else: player.move_component.apply_air_resistance(delta)

	player.flip_component.update_facing(
		command.move_direction
	)
	
	if player.jump_component.can_jump():
		return PlayerTransition.Type.JUMP

	if player.is_on_floor():
		return PlayerTransition.Type.IDLE


	return PlayerTransition.Type.NONE
