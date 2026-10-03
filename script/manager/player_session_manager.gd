extends Node


const MAX_PLAYERS := 4

var player_session_scene: PackedScene
var session_container: Node
var character_roster: CharacterRoster


func _input(event: InputEvent) -> void:
	if GameFlowManager.state != GameState.Type.GAMEPLAY:
		return

	if not event.is_action_pressed("jump"):
		return

	var device := PlayerInputDevice.from_event(event)

	if device == null:
		return

	var session := get_session_for_device(device)

	if session == null:
		join_device(device)
		return

	if session.state == PlayerSession.State.READY:
		PlayerLifecycleManager.activate_session_player(session)


func setup(
	session_scene: PackedScene,
	container: Node
) -> void:
	assert(
		session_scene != null,
		"PlayerSessionManager requires a PlayerSession scene"
	)
	assert(
		container != null,
		"PlayerSessionManager requires a session container"
	)
	
	player_session_scene = session_scene
	session_container = container


func join_device(
	device: PlayerInputDevice
) -> PlayerSession:
	var existing_session := get_session_for_device(device)

	if existing_session != null:
		return existing_session
		
	var player_slot := get_available_player_slot()

	if player_slot == -1:
		print("JOIN REQUEST REJECTED: no available player slot")
		return null
	
	var character_index := -1

	if GameFlowManager.state == GameState.Type.GAMEPLAY:
		character_index = get_first_available_character_index()

		if character_index == -1:
			print("JOIN REJECTED: no available character")
			return null

	var session := create_session(
		player_slot,
		device
	)

	
	if character_index != -1:
		session.selection.select_character(
			character_index,
			character_roster.get_character_count()
		)
		session.selection.confirm()

		print(
			"AUTO ASSIGN: slot=", session.player_slot,
			" character=", session.selection.character_index
		)


	EventManager.player_session_joined.emit(player_slot)

	return session


func create_session(
	player_slot: int,
	device: PlayerInputDevice
) -> PlayerSession:

	var session := (
		player_session_scene.instantiate()
		as PlayerSession
	)

	session.player_slot = player_slot
	session.name = "PlayerSession%s" % player_slot

	session_container.add_child(session)

	session.input.game_input_contexts = (
		GameFlowManager.input_contexts
	)

	session.input.assign_device(device)

	return session


func get_session(
	player_slot: int
) -> PlayerSession:
	for child in session_container.get_children():
		var session := child as PlayerSession

		if session != null and session.player_slot == player_slot:
			return session

	return null


func get_session_for_device(
	device: PlayerInputDevice
) -> PlayerSession:
	for session in get_sessions():
		if not session.input.is_assigned():
			continue

		if session.input.device.matches(device):
			return session

	return null


func get_available_player_slot() -> int:
	for player_slot in range(1, MAX_PLAYERS + 1):
		if not is_player_slot_used(player_slot):
			return player_slot

	return -1


func is_player_slot_used(
	player_slot: int
) -> bool:
	for child in session_container.get_children():
		var session := child as PlayerSession

		if session == null:
			continue

		if session.player_slot == player_slot:
			return true

	return false


func get_sessions() -> Array[PlayerSession]:
	var sessions: Array[PlayerSession] = []

	for child in session_container.get_children():
		var session := child as PlayerSession

		if session != null:
			sessions.append(session)

	return sessions


func get_first_available_character_index() -> int:
	if character_roster == null:
		push_error("CharacterRoster is not configured")
		return -1

	var unavailable: Array[int] = []

	for session in get_sessions():
		if not session.selection.confirmed:
			continue

		unavailable.append(
			session.selection.character_index
		)

	for index in range(
		character_roster.get_character_count()
	):
		if index not in unavailable:
			return index

	return -1
