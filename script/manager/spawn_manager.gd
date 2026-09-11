extends Node

var player_container: Node = null

var players: Dictionary[int, Player] = {}


func spawn_player(
	player_id: int,
	spawn_position: Vector2
) -> Player:

	var existing_player := get_player(player_id)

	if existing_player != null:
		existing_player.global_position = spawn_position
		return existing_player

	var player := create_player(player_id)

	players[player_id] = player
	player_container.add_child(player)

	player.global_position = spawn_position

	return player


func position_player(
	player_id: int,
	position: Vector2
) -> void:

	var player := get_player(player_id)

	if player == null:
		return

	player.global_position = position

func create_player(player_id: int) -> Player:
	var player := preload("res://scene/player.tscn").instantiate() as Player

	player.name = "Player_%s" % player_id
	player.player_id = player_id

	return player


func get_player(player_id: int) -> Player:
	return players.get(player_id)
