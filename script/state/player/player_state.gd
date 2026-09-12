class_name PlayerState
extends State

@export var can_move: bool = true

@export var player: Player


func physics_update(
	_delta: float,
	_command: PlayerCommand
) -> PlayerTransition.Type:
	return PlayerTransition.Type.NONE


func can_enter() -> bool:
	return true


func can_exit() -> bool:
	return true
