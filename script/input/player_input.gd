class_name PlayerInput
extends Node


var input_contexts := InputContextStack.new()
var game_input_contexts: InputContextStack

var control_targets: Array[Node] = []
var device: PlayerInputDevice

@onready var input_source: PlayerInputSource = $InputSource


func assign_device(
	input_device: PlayerInputDevice
) -> void:
	device = input_device
	input_source.assign_device(input_device)


func is_assigned() -> bool:
	return device != null


func set_control_target(target: Node) -> void:
	assert(
		Controllable.is_controllable(target),
		"Control target must implement handle_command(delta, command)"
	)

	control_targets.clear()
	control_targets.push_back(target)


func get_control_target() -> Node:
	if control_targets.is_empty():
		return null

	return control_targets.back()


func push_control_target(target: Node) -> void:
	assert(
		Controllable.is_controllable(target),
		"Control target must implement handle_command(delta, command)"
	)

	control_targets.push_back(target)


func pop_control_target() -> Node:
	if control_targets.is_empty():
		return null

	return control_targets.pop_back()


func clear_control_targets() -> void:
	control_targets.clear()


func get_command() -> PlayerCommand:
	if device == null:
		return null

	if game_input_contexts == null:
		return null

	if game_input_contexts.get_context() != InputContext.Type.GAMEPLAY:
		return null

	if not input_contexts.is_empty():
		return null

	return input_source.get_command(device)
