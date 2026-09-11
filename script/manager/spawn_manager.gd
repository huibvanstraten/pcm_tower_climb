extends Node2D

const PLAYER_SCENE = preload("res://scene/player.tscn")

var players: Dictionary[int, Player] = {}
var last_spawn_points: Dictionary[int, StringName] = {}


func set_spawn_point(player_id: int, spawn_point_name: StringName) -> void:
	last_spawn_points[player_id] = spawn_point_name


func spawn_player(player_id: int, default_spawn_position: Vector2) -> Player:
	if players.has(player_id):
		return respawn_player(player_id, default_spawn_position)

	var player := create_player(player_id)

	players[player_id] = player

	var level = LevelManager.get_current_level()
	level.add_child(player)

	player.global_position = get_spawn_position(
		player_id,
		default_spawn_position,
		level
	)

	EventManager.spawn_player.emit(player)

	return player


func respawn_player(player_id: int, default_spawn_position: Vector2) -> Player:
	var player := get_player(player_id)

	if player == null:
		return spawn_player(player_id, default_spawn_position)

	reset_player(player)

	var level = LevelManager.get_current_level()

	player.global_position = get_spawn_position(
		player_id,
		default_spawn_position,
		level
	)

	EventManager.change_background.emit(1)

	return player


func get_player(player_id: int) -> Player:
	return players.get(player_id)


func get_players() -> Array[Player]:
	var result: Array[Player] = []

	for player in players.values():
		result.append(player)

	return result


func remove_player(player_id: int) -> void:
	var player := get_player(player_id)

	if player == null:
		return

	players.erase(player_id)
	last_spawn_points.erase(player_id)

	player.queue_free()


func clear_players() -> void:
	for player in players.values():
		player.queue_free()

	players.clear()
	last_spawn_points.clear()


func create_player(player_id: int) -> Player:
	var player := PLAYER_SCENE.instantiate() as Player

	player.name = "Player_%s" % player_id
	player.player_id = player_id

	return player


func reset_player(player: Player) -> void:
	# Reset player-specific components here when respawning.
	#
	# Example:
	#
	# var health := player.find_child("Health") as HealthComponent
	# if health:
	#     health.reset_health()
	#
	# var physics := player.find_child("Physics") as PhysicsComponent
	# if physics:
	#     physics.reset_velocity()

	pass


func get_spawn_position(
	player_id: int,
	default_spawn_position: Vector2,
	level: Level,
) -> Vector2:
	var spawn_point_name = last_spawn_points.get(player_id)

	if spawn_point_name == null:
		return default_spawn_position

	var spawn_point = level.get_spawn_point(spawn_point_name)

	if spawn_point == null:
		push_warning(
			"Spawn point '%s' not found for player %s"
			% [spawn_point_name, player_id]
		)
		return default_spawn_position

	return spawn_point.global_position
