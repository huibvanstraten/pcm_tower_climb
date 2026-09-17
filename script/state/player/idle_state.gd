class_name IdleState
extends PlayerState


func enter():
	super()
	print("IDLE STATE")
	

func physics_update(
	delta: float,
	command: PlayerCommand
) -> PlayerTransition.Type:
	player.move_component.stop(delta)

	if command.move_direction != 0.0:
		return PlayerTransition.Type.MOVE
	
	if command.interact_pressed:
		return PlayerTransition.Type.PROGRAM

	if player.jump_component.can_jump():
		return PlayerTransition.Type.JUMP

	if not player.is_on_floor():
		return PlayerTransition.Type.FALL

	return PlayerTransition.Type.NONE
