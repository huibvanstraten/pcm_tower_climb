class_name RespawnPoint
extends Node2D

var players_in_range: Array[Player] = []


func _ready() -> void:
	EventManager.programming_started.connect(_on_programming_started)
	

func _on_programming_started(player: Player) -> void:
	if player not in players_in_range:
		return

	print("RESPAWN REQUESTED BY: ", player.name)

	EventManager.respawn_requested.emit(global_position)


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
	print("RESPAWN POINT: player exited: ", player.name)
