class_name PlayerHUDSlot
extends PanelContainer


enum State {
	EMPTY,
	READY,
	PLAYING,
}


@onready var label: Label = $CenterContainer/Label


func _ready() -> void:
	set_state(State.EMPTY)


func set_state(state: PlayerHUDSlot.State) -> void:
	visible = true

	match state:
		State.EMPTY:
			label.visible = false

		State.READY:
			label.visible = true
			label.text = "PRESS BUTTON TO PLAY"

		State.PLAYING:
			label.visible = true
			label.text = "PLAYER"
