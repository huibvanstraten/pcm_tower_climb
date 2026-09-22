class_name PlayerSelect
extends Control


@onready var slots: Array[PlayerSelectSlot] = [
	%PlayerSelectSlot1,
	%PlayerSelectSlot2,
	%PlayerSelectSlot3,
	%PlayerSelectSlot4,
]


func _ready() -> void:
	EventManager.state_changed.connect(_on_game_state_changed)

	_update_visibility(GameFlowManager.current_state)

	if GameFlowManager.current_state == GameState.Type.PLAYER_SELECT:
		refresh_sessions()


func refresh_sessions() -> void:
	for slot in slots:
		slot.clear_session()

	for session in PlayerSessionManager.get_sessions():
		var slot := get_slot(session.player_slot)

		if slot != null:
			slot.assign_session(session)


func get_slot(
	player_slot: int
) -> PlayerSelectSlot:
	for slot in slots:
		if slot.player_slot == player_slot:
			return slot

	return null


func _on_game_state_changed(
	state: GameState.Type
) -> void:
	_update_visibility(state)

	if state == GameState.Type.PLAYER_SELECT:
		refresh_sessions()


func _update_visibility(
	state: GameState.Type
) -> void:
	visible = state == GameState.Type.PLAYER_SELECT
