class_name MoveState
extends PlayerState


func enter():
	super()
	print("MOVE STATE")

func physics_update(
	delta: float,
	command: PlayerCommand
) -> PlayerTransition.Type:

	if command.move_direction != 0.0:
		player.move_component.move(
			delta,
			command.move_direction
		)
	else:
		player.move_component.stop(delta)

	player.flip_component.update_facing(
		command.move_direction
	)

	if player.jump_component.can_jump():
		return PlayerTransition.Type.JUMP

	if not player.is_on_floor():
		return PlayerTransition.Type.FALL

	return PlayerTransition.Type.NONE
