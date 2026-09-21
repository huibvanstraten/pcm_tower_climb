class_name ProgrammingState 
extends PlayerState

const NAME := "Program"
@export var move_component: MoveComponent

func enter() -> void:
	super()
	move_component.accute_stop()

func exit() -> void:
	super()

func physics_update(delta: float) -> void:
	if player.is_hit():
		state_machine.change_state(HitState.NAME)
	elif player.command.interact_pressed:
		state_machine.change_state(IdleState.NAME)
