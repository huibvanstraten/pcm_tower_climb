class_name State
extends Node

# Only used for debugging purposes (print state transitions)
@export var state_machine: StateMachine

@export var entity: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D
@export var start_animation_name: String

func enter() -> void:
	print("{0}: Enter\t{1}".format([entity.name, state_machine.current_state.name]))
	animated_sprite.play(start_animation_name)
	
func exit() -> void:
	print("{0}: Exit\t{1}".format([entity.name, state_machine.current_state.name]))

func physics_update(delta: float) -> String:
	return "None"
