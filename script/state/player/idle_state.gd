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

	if entity.is_hit():
		return HitState.NAME
	elif entity.velocity.y > 0.0:
		return FallState.NAME
	elif entity.command.move_direction != 0.0:
		return MoveState.NAME
	elif entity.command.jump_pressed:
		return JumpState.NAME
	elif entity.command.interact_pressed:
		return ProgrammingState.NAME
	else:
		return "None"
