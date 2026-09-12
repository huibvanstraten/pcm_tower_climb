class_name PlayerInputSource
extends Node


var input_device: PlayerInputDevice


func assign_device(device: PlayerInputDevice) -> void:
	input_device = device


func get_command(
	_device: PlayerInputDevice
) -> PlayerCommand:
	return PlayerCommand.new()
