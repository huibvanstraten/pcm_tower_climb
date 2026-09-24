class_name PlayerSelect
extends Control

@onready var slots: Array[PlayerSelectSlot] = [
	%PlayerSelectSlot1,
	%PlayerSelectSlot2,
	%PlayerSelectSlot3,
	%PlayerSelectSlot4,
]
@onready var start_game_label: Label = %StartGameLabel

@export var character_roster: CharacterRoster

const AXIS_THRESHOLD := 0.6
const AXIS_RELEASE_THRESHOLD := 0.3

var horizontal_axis_active: Dictionary = {}



func _ready() -> void:
	assert(
		character_roster != null
		and not character_roster.characters.is_empty(),
		"PlayerSelect requires a populated CharacterRoster"
	)
	
	for slot in slots:
		slot.character_roster = character_roster

	EventManager.state_changed.connect(_on_game_state_changed)
	EventManager.player_session_joined.connect(_on_player_session_joined)

	_update_visibility(GameFlowManager.state)

	if GameFlowManager.state == GameState.Type.PLAYER_SELECT:
		refresh_sessions()

func _input(event: InputEvent) -> void:
	if GameFlowManager.state != GameState.Type.PLAYER_SELECT:
		return

	var device := PlayerInputDevice.from_event(event)

	if device == null:
		return

	var session = PlayerSessionManager.get_session_for_device(device)

	if session == null:
		_handle_unassigned_device_input(event, device)
		return

	_handle_session_input(event, session)
	
	
func _update_start_game_state() -> void:
	if are_all_sessions_confirmed():
		start_game_label.modulate.a = 1.0
	else:
		start_game_label.modulate.a = 0.0


func _handle_session_input(
	event: InputEvent,
	session: PlayerInputSession
) -> void:
	if session.selection.confirmed:
		_handle_confirmed_session_input(event)
		return

	if event is InputEventJoypadMotion:
		_handle_joypad_motion(event, session)
		return

	if event.is_action_pressed("move_left"):
		_select_previous_character(session)
	elif event.is_action_pressed("move_right"):
		_select_next_character(session)
	elif event.is_action_pressed("start"):
		_confirm_selection(session)
	else:
		return

	_refresh_slot(session)


func _handle_confirmed_session_input(
	event: InputEvent
) -> void:
	if not event.is_action_pressed("start"):
		return

	if not are_all_sessions_confirmed():
		return

	_start_game()


func _start_game() -> void:
	for session in PlayerSessionManager.get_sessions():
		print(
			"START GAME: slot=", session.player_slot,
			" character=", session.selection.character_index,
			" confirmed=", session.selection.confirmed
		)
	
	if not are_all_sessions_confirmed():
		return

	GameFlowManager.change_state(
		GameState.Type.GAMEPLAY
	)
	
	

func _refresh_slot(
	session: PlayerInputSession
) -> void:
	var slot := get_slot(session.player_slot)

	if slot == null:
		return

	slot.assign_session(session)
	
	
func _handle_unassigned_device_input(
	event: InputEvent,
	device: PlayerInputDevice
) -> void:
	if not event.is_action_pressed("start"):
		return

	PlayerSessionManager.join_device(device)

func refresh_sessions() -> void:
	for slot in slots:
		slot.clear_session()

	for session in PlayerSessionManager.get_sessions():
		var slot := get_slot(session.player_slot)

		if slot != null:
			slot.assign_session(session)

	_update_start_game_state()


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


func _on_player_session_joined(
	player_slot: int
) -> void:
	if GameFlowManager.state != GameState.Type.PLAYER_SELECT:
		return

	var session = PlayerSessionManager.get_session(player_slot)

	if session != null:
		_ensure_available_character(session)

	refresh_sessions()
	_update_start_game_state()


func _ensure_available_character(
	session: PlayerInputSession
) -> void:
	var unavailable := _get_unavailable_character_indices(session)

	if session.selection.character_index not in unavailable:
		return

	_select_next_character(session)
	

func _update_visibility(
	state: GameState.Type
) -> void:
	visible = state == GameState.Type.PLAYER_SELECT
	

func _get_unavailable_character_indices(
	excluded_session: PlayerInputSession = null
) -> Array[int]:
	var unavailable: Array[int] = []

	for session in PlayerSessionManager.get_sessions():
		if session == excluded_session:
			continue

		if not session.selection.confirmed:
			continue

		unavailable.append(session.selection.character_index)

	return unavailable


func _select_next_character(
	session: PlayerInputSession
) -> void:
	var unavailable := _get_unavailable_character_indices(session)
	var current := session.selection.character_index
	var count := character_roster.get_character_count()

	for offset in range(1, count + 1):
		var candidate := wrapi(
			current + offset,
			0,
			count
		)

		if candidate not in unavailable:
			session.selection.select_character(candidate, count)
			return


func _select_previous_character(
	session: PlayerInputSession
) -> void:
	var unavailable := _get_unavailable_character_indices(session)
	var current := session.selection.character_index
	var count := character_roster.get_character_count()

	for offset in range(1, count + 1):
		var candidate := wrapi(
			current - offset,
			0,
			count
		)

		if candidate not in unavailable:
			session.selection.select_character(candidate, count)
			return


func _confirm_selection(
	session: PlayerInputSession
) -> void:
	var unavailable := _get_unavailable_character_indices(session)

	if session.selection.character_index in unavailable:
		return

	session.selection.confirm()
	
	print(
	"PLAYER SELECT: slot=", session.player_slot,
	" character=", session.selection.character_index,
	" confirmed=", session.selection.confirmed
)

	_resolve_selection_conflicts(session)
	_update_start_game_state()


func are_all_sessions_confirmed() -> bool:
	var sessions = PlayerSessionManager.get_sessions()

	if sessions.is_empty():
		return false

	for session in sessions:
		if not session.selection.confirmed:
			return false

	return true


func _resolve_selection_conflicts(
	confirmed_session: PlayerInputSession
) -> void:
	var confirmed_character := (
		confirmed_session.selection.character_index
	)

	for session in PlayerSessionManager.get_sessions():
		if session == confirmed_session:
			continue

		if session.selection.confirmed:
			continue

		if (
			session.selection.character_index
			!= confirmed_character
		):
			continue

		_select_next_character(session)
		_refresh_slot(session)

func _handle_joypad_motion(
	event: InputEventJoypadMotion,
	session: PlayerInputSession
) -> void:
	if event.axis != JOY_AXIS_LEFT_X:
		return

	var device_id := event.device
	var is_active: bool = horizontal_axis_active.get(device_id, false)

	if abs(event.axis_value) <= AXIS_RELEASE_THRESHOLD:
		horizontal_axis_active[device_id] = false
		return

	if is_active:
		return

	if event.axis_value <= -AXIS_THRESHOLD:
		_select_previous_character(session)
	elif event.axis_value >= AXIS_THRESHOLD:
		_select_next_character(session)
	else:
		return

	horizontal_axis_active[device_id] = true
	_refresh_slot(session)
