class_name PlayerCommand
extends RefCounted

var move_direction: float = 0.0
var jump_pressed: bool = false
var jump_held: bool = false
var jump_released: bool = false
var interact_pressed: bool = false

func _to_string() -> String:
	return "PlayerCommand(move=%s, jump_p=%s, jump_h=%s, jump_r=%s, interact_p=%s, interact_r=%s)" % [
		move_direction, jump_pressed, jump_held, jump_released, interact_pressed, interact_released
	]
