class_name PlayerInputSession
extends Node


@export var player_slot: int

var control_target: Node
var input_device: PlayerInputDevice


@onready var input_source: PlayerInputSource = $InputSource

func assign_device(device: PlayerInputDevice) -> void:
	input_device = device
	input_source.assign_device(device)
	
	
func set_control_target(target: Node) -> void:
	assert(
		Controllable.is_controllable(target),
		"Control target must implement handle_command(delta, command)"
	)

	control_target = target


func release_control() -> void:
	control_target = null


func _physics_process(delta: float) -> void:
	if control_target == null:
		return

	if input_device == null:
		return

	var command := input_source.get_command(
		input_device
	)

	control_target.handle_command(
		delta,
		command
	)


func is_joined() -> bool:
	return input_device != null
