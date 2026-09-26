class_name PlayerState
extends State

@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent
@export var jump_component: JumpComponent

func enter() -> void:
	animation_player.play(start_animation_name)
	super()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	return "None"
