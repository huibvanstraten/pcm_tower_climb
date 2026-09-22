class_name PlayerState
extends State

@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent
@export var jump_component: JumpComponent

func enter() -> void:
	super()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	return "None"
