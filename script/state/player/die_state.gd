class_name DieState
extends PlayerState

const NAME := "Die"
@export var physics_component: PhysicsComponent

func enter() -> void:
	super()
	physics_component.halt_horizontal()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	return "None"
