class_name MoveState
extends PlayerState

const NAME := "Move"
@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent

func enter() -> void:
	super()

func exit() -> void:
	super()

func physics_update(delta: float) -> void:
	physics_component.apply_gravity(delta)
	move_component.move(delta, player.command.move_direction)
	flip_component.update_facing(player.command.move_direction)

	if player.is_hit():
		state_machine.change_state(HitState.NAME)
	elif player.command.jump_pressed:
		state_machine.change_state(JumpState.NAME)
	elif player.command.interact_pressed:
		state_machine.change_state(ProgrammingState.NAME)
	elif player.velocity.x == 0.0:
		state_machine.change_state(IdleState.NAME)
