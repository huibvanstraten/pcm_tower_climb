class_name State
extends Node

var state_machine: StateMachine

@export var entity: CharacterBody2D
@export var animation_sprite: AnimatedSprite2D
@export var animation_player: AnimationPlayer
@export var collision_shape: CollisionShape2D

#@export var state_name: String
#@export var animation_name: String
#@export var sfx_name: String

#var entity_hit: bool = false

#func initialize():
	#EventManager.connect("entity_hit", _on_entity_hit)

func enter() -> void:
	print("{0}: Enter\t{1}".format([entity.name, state_machine.current_state.name]))
	#if not animation_name.is_empty():
		#animation_player.play(animation_name)

func exit() -> void:
	print("{0}: Exit\t{1}".format([entity.name, state_machine.current_state.name]))

func handle_command(command: PlayerCommand) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
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
