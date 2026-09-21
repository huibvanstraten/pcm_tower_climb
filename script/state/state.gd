class_name State
extends Node

# Only used for debugging purposes (print state transitions)
@export var state_machine: PlayerStateMachine
# TODO: rename to enitity
@export var player: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var collision_shape: CollisionShape2D
@export var start_animation_name: String

func enter() -> void:
	print("{0}: Enter\t{1}".format([player.name, state_machine.current_state.name]))
	animation_player.play(start_animation_name)
	
func exit() -> void:
	print("{0}: Exit\t{1}".format([player.name, state_machine.current_state.name]))

func physics_update(delta: float) -> String:
	return "None"
