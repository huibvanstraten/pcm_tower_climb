class_name State
extends Node

@export var character_body: CharacterBody2D = null
@export var node_animation_sprite: AnimatedSprite2D = null
@export var node_animation: AnimationPlayer = null
@export var collision_shape: CollisionShape2D = null

@export var state_name: String
@export var animation_name: String
@export var sfx_name: String

var entity_hit: bool = false


func initialize():
	EventManager.connect("entity_hit", _on_entity_hit)


func enter():
	if node_animation != null and animation_name != "":
		node_animation.play(animation_name)


func exit():
	pass


func _on_entity_hit(entity: CharacterBody2D):
	entity_hit = character_body == entity and check_state_type(entity)


func check_state_type(entity: CharacterBody2D) -> bool:
	var stateMachine := entity.find_child("StateMachine") as StateMachine

	if stateMachine == null or stateMachine.currentState == null:
		return false

	return stateMachine.currentState.stateName == state_name


func get_previous_state_type(entity: CharacterBody2D) -> String:
	var stateMachine := entity.find_child("StateMachine") as StateMachine

	if stateMachine == null or stateMachine.previousState == null:
		return ""

	return stateMachine.previousState.stateName
