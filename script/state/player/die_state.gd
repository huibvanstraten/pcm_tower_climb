class_name DieState
extends PlayerState

const NAME := "Die"


func enter() -> void:
	super()
	animated_sprite.rotate(-0.5*PI)
	physics_component.halt_horizontal()
	EventManager.player_died.emit(entity)

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)
	return "None"
