class_name ProgrammingState 
extends PlayerState

const NAME := "Program"
@export var move_component: MoveComponent

func enter() -> void:
	super()
	move_component.accute_stop()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	if player.is_hit():
		return HitState.NAME
	elif player.command.interact_pressed:
		return IdleState.NAME
	else:
		return "None"
