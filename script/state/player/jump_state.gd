class_name JumpState
extends PlayerState

const NAME := "Jump"
@export var jump_component: JumpComponent
@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent

func enter() -> void:
	super()
	jump_component.jump()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)
	move_component.move_in_air(delta, player.command.move_direction)
	flip_component.update_facing(player.command.move_direction)

	if player.is_hit():
		return HitState.NAME
	elif player.velocity.y > 0.0:
		return FallState.NAME
	else:
		return "None"
