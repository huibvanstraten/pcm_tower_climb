class_name PlayerSelection
extends RefCounted


const CHARACTER_COUNT := 4

var character_index: int = 0
var confirmed: bool = false


func select_character(index: int) -> void:
	if confirmed:
		return

	character_index = index


func confirm() -> void:
	confirmed = true
