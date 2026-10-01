class_name PlayerSession
extends Node


enum State {
	READY,
	PLAYING,
	WAITING,
}


@export var player_slot: int

var state: PlayerSession.State = State.READY
var selection := PlayerSelection.new()
var progress := PlayerProgress.new()

@onready var input: PlayerInput = $PlayerInput


func _physics_process(_delta: float) -> void:
	if state != State.PLAYING:
		return

	var command := input.get_command()

	if command == null:
		return

	var control_target := input.get_control_target()

	if control_target == null:
		return

	control_target.handle_command(command)


func is_joined() -> bool:
	return input.is_assigned()


func activate(target: Node) -> void:
	input.set_control_target(target)
	state = State.PLAYING


func deactivate() -> void:
	input.clear_control_targets()
	state = State.WAITING


func wait_for_spawn() -> void:
	state = State.WAITING

	EventManager.player_session_waiting.emit(
		player_slot
	)
