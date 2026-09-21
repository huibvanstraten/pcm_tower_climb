class_name FallState
extends PlayerState

const NAME := "Fall"
@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent

func enter() -> void:
	super()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)
	move_component.move_in_air(delta, player.command.move_direction)
	flip_component.update_facing(player.command.move_direction)

	if player.is_hit():
		return HitState.NAME
	elif player.is_on_floor():
		if player.command.move_direction != 0.0:
			return MoveState.NAME
		else:
			return IdleState.NAME
	else:
		return "None"
