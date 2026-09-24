extends Node

var character_roster: CharacterRoster


func _ready() -> void:
	EventManager.player_died.connect(kill_player)
	EventManager.respawn_requested.connect(respawn_players)


func get_session_character(
	session: PlayerInputSession
) -> CharacterData:
	if character_roster == null:
		push_error("CharacterRoster is not configured")
		return null

	var character := character_roster.get_character(
		session.selection.character_index
	)

	if character == null:
		push_error(
			"No character for session %s"
			% session.player_slot
		)

	return character
	

func activate_session_player(
	session: PlayerInputSession
) -> void:
	var character := get_session_character(session)

	if character == null:
		return
	
	if not can_use_initial_spawn_points():
		session.wait_for_spawn()
		return

	var level = LevelManager.get_current_level()

	var spawn_position: Vector2 = level.get_player_start_position(
		session.player_slot
	)

	var player = SpawnManager.get_player(session.player_slot)

	if player == null:
		player = SpawnManager.spawn_player(
			session.player_slot,
			spawn_position,
			character,
		)
	else:
		SpawnManager.position_player(
			session.player_slot,
			spawn_position
		)

	session.activate(player)

	EventManager.player_joined.emit(player)
	

func kill_player(
	player: Player
) -> void:
	var session := PlayerSessionManager.get_session(player.player_id)

	if session == null:
		return

	session.deactivate()
	SpawnManager.remove_player(player.player_id)

	print("PLAYER DIED: ", player.player_id)
	

func respawn_players(
	spawn_positions: Array[Vector2]
) -> void:
	var spawn_index := 0

	for session in PlayerSessionManager.get_sessions():
		if session.state != PlayerInputSession.State.WAITING:
			continue

		if spawn_index >= spawn_positions.size():
			push_error("Not enough respawn positions for dead players")
			return

		var character := get_session_character(session)

		if character == null:
			continue
			
		print(
			"SPAWNING: slot=", session.player_slot,
			" character=", character.display_name,
			" index=", session.selection.character_index
		)

		var player := SpawnManager.spawn_player(
			session.player_slot,
			spawn_positions[spawn_index],
			character
		)

		session.activate(player)
		spawn_index += 1

		EventManager.player_respawned.emit(player)
		

func position_joined_players() -> void:
	var level = LevelManager.get_current_level()

	for session in PlayerSessionManager.get_sessions():
		if session.input_device == null:
			continue

		var player = SpawnManager.get_player(session.player_slot)

		if player == null:
			continue

		var spawn_position: Vector2 = level.get_player_start_position(
			session.player_slot
		)

		SpawnManager.position_player(
			session.player_slot,
			spawn_position
		)
		

func can_use_initial_spawn_points() -> bool:
	var level = LevelManager.get_current_level()
	var camera_rig := level.camera_rig as CameraRig

	for player_slot in range(1, 4):
		var spawn_position: Vector2 = (
			level.get_player_start_position(player_slot)
		)

		if camera_rig.is_world_position_visible(spawn_position):
			return true

	return false
