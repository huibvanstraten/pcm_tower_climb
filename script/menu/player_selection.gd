class_name PlayerSelection
extends RefCounted


var character_index: int = 0
var confirmed: bool = false


func select_character(
	index: int,
	character_count: int
) -> void:
	if confirmed:
		return

	if index < 0 or index >= character_count:
		return

	character_index = index


func confirm() -> void:
	confirmed = true
