class_name PlayerSelectSlot
extends PanelContainer


enum State {
	EMPTY,
	SELECTING,
	CONFIRMED,
}


@export var player_slot: int

var state: PlayerSelectSlot.State = State.EMPTY
var session: PlayerInputSession = null

@onready var player_label: Label = %PlayerLabel
@onready var character_label: Label = %CharacterLabel
@onready var status_label: Label = %StatusLabel


func _ready() -> void:
	_update_ui()


func assign_session(
	player_session: PlayerInputSession
) -> void:
	session = player_session
	state = State.SELECTING
	_update_ui()


func clear_session() -> void:
	session = null
	state = State.EMPTY
	_update_ui()


func confirm() -> void:
	if state != State.SELECTING:
		return

	state = State.CONFIRMED
	_update_ui()


func _update_ui() -> void:
	if not is_node_ready():
		return

	player_label.text = "PLAYER %s" % player_slot

	match state:
		State.EMPTY:
			character_label.text = ""
			status_label.text = "PRESS START TO JOIN"

		State.SELECTING:
			character_label.text = "CHARACTER 1"
			status_label.text = "<  >"

		State.CONFIRMED:
			character_label.text = "CHARACTER 1"
			status_label.text = "READY"
