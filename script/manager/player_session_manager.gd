extends Node


const MAX_PLAYERS := 4

var player_input_session_scene: PackedScene
var input_session_container: Node


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

	if session.state == PlayerInputSession.State.READY:
		PlayerLifecycleManager.activate_session_player(session)


func setup(
	session_scene: PackedScene,
	session_container: Node
) -> void:
	player_input_session_scene = session_scene
	input_session_container = session_container


func join_device(
	device: PlayerInputDevice
) -> PlayerInputSession:
	var player_slot := get_available_player_slot()

	if player_slot == -1:
		print("JOIN REQUEST REJECTED: no available player slot")
		return null

	var session := create_input_session(
		player_slot,
		device
	)

	EventManager.player_session_joined.emit(player_slot)

	return session


func create_input_session(
	player_slot: int,
	device: PlayerInputDevice
) -> PlayerInputSession:
	var session := (
		player_input_session_scene.instantiate()
		as PlayerInputSession
	)

	session.game_input_contexts = GameFlowManager.input_contexts
	session.player_slot = player_slot
	session.name = "PlayerInputSession%s" % player_slot

	input_session_container.add_child(session)
	session.assign_device(device)

	return session


func get_session(
	player_slot: int
) -> PlayerInputSession:
	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session != null and session.player_slot == player_slot:
			return session

	return null


func get_session_for_device(
	device: PlayerInputDevice
) -> PlayerInputSession:
	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if session.input_device == null:
			continue

		if session.input_device.matches(device):
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
	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if session.player_slot == player_slot:
			return true

	return false


func get_sessions() -> Array[PlayerInputSession]:
	var sessions: Array[PlayerInputSession] = []

	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session != null:
			sessions.append(session)

	return sessions
