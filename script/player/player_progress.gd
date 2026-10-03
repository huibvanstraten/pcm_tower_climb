class_name PlayerProgress
extends RefCounted


signal fragments_changed(current_amount: int)


var fragments: int = 0


func add_fragments(
	amount: int
) -> void:
	if amount <= 0:
		return

	fragments += amount
	fragments_changed.emit(fragments)


func remove_fragments(
	amount: int
) -> int:
	if amount <= 0:
		return 0

	var removed := mini(
		amount,
		fragments
	)

	if removed == 0:
		return 0

	fragments -= removed
	fragments_changed.emit(fragments)

	return removed
