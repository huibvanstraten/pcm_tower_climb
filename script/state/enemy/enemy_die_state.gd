class_name EnemyDieState
extends EnemyState

const NAME := "Die"


func enter() -> void:
	super()
	physics_component.halt_horizontal()
	entity.queue_free()


func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	return "None"
