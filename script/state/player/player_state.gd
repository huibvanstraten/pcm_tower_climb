class_name PlayerState
extends Node

@export var state_machine: PlayerStateMachine
@export var player: CharacterBody2D
@export var animation_sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var collision_shape: CollisionShape2D

func enter() -> void:
	print("{0}: Enter\t{1}".format([player.name, state_machine.current_state.name]))
	pass

func exit() -> void:
	print("{0}: Exit\t{1}".format([player.name, state_machine.current_state.name]))
	pass

func physics_update(delta: float) -> void:
	pass
