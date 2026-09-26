class_name CharacterRoster
extends Resource

@export var characters: Array[CharacterData] = []


func get_character(index: int) -> CharacterData:
	if index < 0 or index >= characters.size():
		return null

	return characters[index]


func get_character_count() -> int:
	return characters.size()
