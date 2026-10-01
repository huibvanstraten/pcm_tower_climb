class_name PlayerProgress
extends RefCounted


signal fragments_changed(amount: int)


var fragments: int = 0


func add_fragments(amount: int) -> void:
	if amount <= 0:
		return

	fragments += amount
	fragments_changed.emit(fragments)


func remove_fragments(amount: int) -> int:
	if amount <= 0:
		return 0

	var removed_amount = min(amount, fragments)

	fragments -= removed_amount
	fragments_changed.emit(fragments)

	return removed_amount
