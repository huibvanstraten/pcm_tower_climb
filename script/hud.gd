extends CanvasLayer


func _ready() -> void:
	$MarginContainer/HBoxContainer/PlayerHUDSlot1.set_state(
		PlayerHUDSlot.State.EMPTY
	)
	$MarginContainer/HBoxContainer/PlayerHUDSlot2.set_state(
		PlayerHUDSlot.State.READY
	)
	$MarginContainer/HBoxContainer/PlayerHUDSlot3.set_state(
		PlayerHUDSlot.State.PLAYING
	)
	$MarginContainer/HBoxContainer/PlayerHUDSlot4.set_state(
		PlayerHUDSlot.State.READY
	)
