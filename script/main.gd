class_name Main
extends Node

@export var player_input_session_scene: PackedScene
@export var availableLevels: Array[LevelData]

@onready var level_container: Node = $LevelContainer
@onready var player_container: Node = $PlayerContainer
@onready var input_session_container: Node = $PlayerInputSessionContainer

var game_input_contexts := InputContextStack.new()

const MAX_PLAYERS := 4


func _ready() -> void:
	game_input_contexts.set_context(InputContext.Type.GAMEPLAY)

	EventManager.level.connect(load_level)
	EventManager.player_died.connect(kill_player)
	EventManager.respawn_requested.connect(respawn_players)

	LevelManager.mainScene = level_container
	LevelManager.levels = availableLevels

	SpawnManager.player_container = player_container

	EventManager.emit_signal("level", 1)


func _input(event: InputEvent) -> void:
	var device := PlayerInputDevice.from_event(event)

	if device == null:
		return

	if not event.is_action_pressed("jump"):
		return

	var session := get_session_for_device(device)

	if session == null:
		join_device(device)
		return


	if session.state == PlayerInputSession.State.READY:
		activate_session_player(session)


func get_players() -> Array[Player]:
	var players: Array[Player] = []

	for child in player_container.get_children():
		if child is Player:
			players.append(child)

	return players


func get_session(player_slot: int) -> PlayerInputSession:
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


func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed:
		return

	if event.keycode == KEY_P:
		game_input_contexts.push_context(InputContext.Type.PAUSE_MENU)

	if event.keycode == KEY_O:
		if game_input_contexts.contexts.size() > 1:
			game_input_contexts.pop_context()

	if event.keycode == KEY_I:
		var session := get_session(1)

		if session != null:
			session.debug_push_inventory()

	if event.keycode == KEY_U:
		var session := get_session(1)

		if session != null:
			session.debug_pop_context()

	if event.keycode == KEY_Y:
		var session := get_session(2)

		if session != null:
			session.debug_push_inventory()

	if event.keycode == KEY_T:
		var session := get_session(2)

		if session != null:
			session.debug_pop_context()


func load_level(level_id: int) -> void:
	LevelManager.load_level(level_id)

	position_joined_players()


func activate_session_player(session: PlayerInputSession) -> void:
	if not can_use_initial_spawn_points():
		return

	var level = LevelManager.get_current_level()

	var spawn_position: Vector2 = level.get_player_start_position(
		session.player_slot
	)

	var player := SpawnManager.get_player(session.player_slot)

	if player == null:
		player = SpawnManager.spawn_player(
			session.player_slot,
			spawn_position
		)
	else:
		SpawnManager.position_player(
			session.player_slot,
			spawn_position
		)

	session.activate(player)

	EventManager.player_joined.emit(player)


func join_device(device: PlayerInputDevice) -> void:
	var player_slot := get_available_player_slot()

	if player_slot == -1:
		print("JOIN REQUEST REJECTED: no available player slot")
		return

	create_input_session(
		player_slot,
		device
	)

	EventManager.player_session_joined.emit(player_slot)


func create_input_session(
	player_slot: int,
	device: PlayerInputDevice
) -> PlayerInputSession:
	var session := player_input_session_scene.instantiate() as PlayerInputSession

	session.game_input_contexts = game_input_contexts

	session.player_slot = player_slot
	session.name = "PlayerInputSession%s" % player_slot

	input_session_container.add_child(session)

	session.assign_device(device)

	return session


func get_available_player_slot() -> int:
	for player_slot in range(1, MAX_PLAYERS + 1):
		if not is_player_slot_used(player_slot):
			return player_slot

	return -1


func position_joined_players() -> void:
	var level = LevelManager.get_current_level()

	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if session.input_device == null:
			continue

		var player := SpawnManager.get_player(session.player_slot)

		if player == null:
			continue

		var spawn_position: Vector2 = level.get_player_start_position(
			session.player_slot
		)

		SpawnManager.position_player(
			session.player_slot,
			spawn_position
		)


func is_player_slot_used(player_slot: int) -> bool:
	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if session.player_slot == player_slot:
			return true

	return false


func kill_player(player: Player) -> void:
	var session := get_session(player.player_id)

	if session == null:
		return

	session.deactivate()
	SpawnManager.remove_player(player.player_id)

	print("PLAYER DIED: ", player.player_id)


func respawn_players(spawn_positions: Array[Vector2]) -> void:
	var spawn_index := 0

	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if session.state == PlayerInputSession.State.PLAYING:
			continue

		if spawn_index >= spawn_positions.size():
			push_error("Not enough respawn positions for dead players")
			return

		var player := SpawnManager.spawn_player(
			session.player_slot,
			spawn_positions[spawn_index]
		)

		session.activate(player)
		spawn_index += 1

		EventManager.player_respawned.emit(player)


func can_use_initial_spawn_points() -> bool:
	var level = LevelManager.get_current_level()
	var camera_rig := level.camera_rig as CameraRig

	for player_slot in range(1, MAX_PLAYERS + 1):
		var spawn_position: Vector2 = \
			level.get_player_start_position(player_slot)

		if camera_rig.is_world_position_visible(spawn_position):
			return true

	return false
