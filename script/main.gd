class_name Main
extends Node

@export var player_input_session_scene: PackedScene
@export var availableLevels: Array[LevelData]

@onready var level_container: Node = $LevelContainer
@onready var player_container: Node = $PlayerContainer
@onready var input_session_container: Node = $PlayerInputSessionContainer

const MAX_PLAYERS := 4


func _ready() -> void:
	PlayerSessionManager.setup(
	player_input_session_scene,
	input_session_container
)
	
	GameFlowManager.start()

	EventManager.level.connect(load_level)
	EventManager.player_died.connect(kill_player)
	EventManager.respawn_requested.connect(respawn_players)

	LevelManager.mainScene = level_container
	LevelManager.levels = availableLevels

	SpawnManager.player_container = player_container


func _input(event: InputEvent) -> void:
	match GameFlowManager.state:
		GameState.Type.START_SCREEN:
			handle_start_screen_input(event)

		GameState.Type.GAMEPLAY:
			handle_gameplay_input(event)
	

func handle_start_screen_input(event: InputEvent) -> void:
	if not event.is_action_pressed("start"):
		return

	var device = PlayerInputDevice.from_event(event)

	if device == null:
		return

	if PlayerSessionManager.get_session_for_device(device) != null:
		return

	var session = PlayerSessionManager.join_device(device)

	if session == null:
		return

	GameFlowManager.change_state(
		GameState.Type.PLAYER_SELECT
	)


func handle_gameplay_input(event: InputEvent) -> void:
	var device := PlayerInputDevice.from_event(event)

	if device == null:
		return

	if not event.is_action_pressed("jump"):
		return

	var session = PlayerSessionManager.get_session_for_device(device)

	if session == null:
		PlayerSessionManager.join_device(device)
		return

	if session.state == PlayerInputSession.State.READY:
		activate_session_player(session)
	

func get_players() -> Array[Player]:
	var players: Array[Player] = []

	for child in player_container.get_children():
		if child is Player:
			players.append(child)

	return players


func load_level(level_id: int) -> void:
	LevelManager.load_level(level_id)

	position_joined_players()


func activate_session_player(session: PlayerInputSession) -> void:
	if not can_use_initial_spawn_points():
		session.wait_for_spawn()
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


func position_joined_players() -> void:
	var level = LevelManager.get_current_level()

	for child in PlayerSessionManager.input_session_container.get_children():
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


func kill_player(player: Player) -> void:
	var session = PlayerSessionManager.get_session(player.player_id)

	if session == null:
		return

	session.deactivate()
	SpawnManager.remove_player(player.player_id)

	print("PLAYER DIED: ", player.player_id)


func respawn_players(spawn_positions: Array[Vector2]) -> void:
	var spawn_index := 0

	for child in PlayerSessionManager.input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if session.state != PlayerInputSession.State.WAITING:
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
