class_name JumpState
extends PlayerState


func enter() -> void:
	super()

	player.jump_component.jump()


func physics_update(
	delta: float,
	command: PlayerCommand
) -> PlayerTransition.Type:
	player.physics_component.apply_gravity(delta)

	player.move_component.move_in_air(
		delta,
		command.move_direction
	)

	player.flip_component.update_facing(
		command.move_direction
	)

	if command.jump_released:
		player.jump_component.stop_jump()

	if player.is_on_ceiling():
		player.jump_component.stop_jump()
		return PlayerTransition.Type.FALL

	if player.is_on_floor():
		return PlayerTransition.Type.MOVE

	if player.velocity.y >= 0.0:
		return PlayerTransition.Type.FALL

	return PlayerTransition.Type.NONE
