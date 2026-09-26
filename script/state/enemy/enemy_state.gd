class_name EnemyState
extends State

@export var physics_component: PhysicsComponent

func enter() -> void:
	animated_sprite.play(start_animation_name)
	super()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	return "None"
