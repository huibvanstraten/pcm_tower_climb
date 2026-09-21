class_name PlayerInputSession
extends Node


@export var player_slot: int

var input_contexts := InputContextStack.new()
var game_input_contexts: InputContextStack

var control_targets: Array[Node] = []
var input_device: PlayerInputDevice

enum State {
	READY,
	PLAYING,
	WAITING,
}

var state: PlayerInputSession.State = State.READY

@onready var input_source: PlayerInputSource = $InputSource


func debug_push_inventory() -> void:
	input_contexts.push_context(InputContext.Type.INVENTORY)
	print(
		"SESSION ",
		player_slot,
		" CONTEXT: ",
		input_contexts.get_context()
	)


func debug_pop_context() -> void:
	input_contexts.pop_context()

	if input_contexts.contexts.is_empty():
		print("SESSION ", player_slot, " CONTEXT: <empty>")
		return

	print(
		"SESSION ",
		player_slot,
		" CONTEXT: ",
		input_contexts.get_context()
	)

func assign_device(device: PlayerInputDevice) -> void:
	input_device = device
	input_source.assign_device(device)


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


func _physics_process(delta: float) -> void:
	if state != State.PLAYING:
		return
	
	if input_device == null:
		return

	var command := input_source.get_command(input_device)

	if game_input_contexts == null:
		return

	if game_input_contexts.get_context() != InputContext.Type.GAMEPLAY:
		return

	if not input_contexts.is_empty():
		return

	var control_target := get_control_target()

	if control_target == null:
		return

	control_target.handle_command(delta, command)


func is_joined() -> bool:
	return input_device != null
	

func activate(target: Node) -> void:
	set_control_target(target)
	state = PlayerInputSession.State.PLAYING


func deactivate() -> void:
	clear_control_targets()
	state = State.WAITING


func wait_for_spawn() -> void:
	state = State.WAITING
	EventManager.player_session_waiting.emit(player_slot)
