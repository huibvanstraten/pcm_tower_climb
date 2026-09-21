class_name IdleState
extends PlayerState

const NAME := "Idle"
@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent

func enter() -> void:
	super()
	physics_component.halt_horizontal()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)

	if player.is_hit():
		return HitState.NAME
	elif player.velocity.y > 0.0:
		return FallState.NAME
	elif player.command.move_direction != 0.0:
		return MoveState.NAME
	elif player.command.jump_pressed:
		return JumpState.NAME
	elif player.command.interact_pressed:
		return ProgrammingState.NAME
	else:
		return "None"
