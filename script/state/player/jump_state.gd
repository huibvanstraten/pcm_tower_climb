class_name JumpState
extends PlayerState


func enter() -> void:
	super()
	player.jump_component.jump()


func physics_update(
	delta: float,
	command: PlayerCommand
) -> PlayerTransition.Type:
	player.physics_component.move_in_air(
		delta,
		command.move_direction
	)

	player.flip_component.update_facing(
		command.move_direction
	)

	if not command.jump_held:
		player.jump_component.stop_jump()

	if player.is_on_ceiling():
		player.jump_component.stop_jump()
		return PlayerTransition.Type.FALL

	if player.velocity.y >= 0.0:
		return PlayerTransition.Type.FALL

	return PlayerTransition.Type.NONE
