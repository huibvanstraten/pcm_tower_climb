class_name RespawnPoint
extends Node2D

var players_in_range: Array[Player] = []
var programming_player: Player = null

@onready var spawn_points: Node2D = $SpawnPoints
@onready var programming_timer: Timer = $ProgrammingTimer


func _ready() -> void:
	EventManager.programming_started.connect(_on_programming_started)
	EventManager.programming_cancelled.connect(_on_programming_cancelled)
	programming_timer.timeout.connect(_on_programming_completed)
	

func _on_programming_started(player: Player) -> void:
	if player not in players_in_range:
		return

	if programming_player != null:
		return

	programming_player = player
	programming_timer.start()

	print("RESPAWN PROGRAMMING STARTED: ", player.name)


func _on_programming_cancelled(player: Player) -> void:
	print("RESPAWN POINT RECEIVED CANCEL: ", player.name)

	if player != programming_player:
		return

	programming_timer.stop()
	programming_player = null

	print("RESPAWN PROGRAMMING CANCELLED")
	

func _on_programming_completed() -> void:
	if programming_player == null:
		return

	var player := programming_player
	programming_player = null

	EventManager.respawn_requested.emit(get_spawn_positions())
	EventManager.programming_finished.emit(player)

	print("RESPAWN PROGRAMMING COMPLETED")


func get_spawn_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []

	for child in spawn_points.get_children():
		var marker := child as Marker2D

		if marker == null:
			continue

		positions.append(marker.global_position)

	return positions


func _on_detection_area_body_entered(body: Node2D) -> void:
	var player := body as Player

	if player == null:
		return

	players_in_range.append(player)
	print("RESPAWN POINT: player entered: ", player.name)


func _on_detection_area_body_exited(body: Node2D) -> void:
	var player := body as Player

	if player == null:
		return

	players_in_range.erase(player)

	if player == programming_player:
		programming_timer.stop()
		programming_player = null
		EventManager.programming_finished.emit(player)
