class_name State
extends Node

var state_machine: StateMachine

@export var entity: CharacterBody2D
@export var animation_sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var collision_shape: CollisionShape2D

func enter() -> void:
	print("{0}: Enter\t{1}".format([entity.name, state_machine.current_state.name]))
	pass

func exit() -> void:
	print("{0}: Exit\t{1}".format([entity.name, state_machine.current_state.name]))
	pass

#func _on_entity_hit(entity: CharacterBody2D):
	#entity_hit = character_body == entity and check_state_type(entity)

#func check_state_type(entity: CharacterBody2D) -> bool:
	#var stateMachine := entity.find_child("StateMachine") as StateMachine
#
	#if stateMachine == null or stateMachine.currentState == null:
		#return false

	#return stateMachine.currentState.stateName == state_name

#func get_previous_state_type(entity: CharacterBody2D) -> String:
	#var stateMachine := entity.find_child("StateMachine") as StateMachine
#
	#if stateMachine == null or stateMachine.previousState == null:
		#return ""
#
	#return stateMachine.previousState.stateName

func handle_command(command: PlayerCommand) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
