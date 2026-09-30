class_name RespawnPoint
extends Node2D

@onready var spawn_points: Node2D = $SpawnPoints
@onready var programmable_component: ProgrammableComponent = $Terminal


func _ready() -> void:
	programmable_component.programming_completed.connect(
		_on_programming_completed
	)


func _on_programming_completed(player: Player) -> void:
	EventManager.respawn_requested.emit(
		get_spawn_positions()
	)

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
