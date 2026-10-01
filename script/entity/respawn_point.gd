class_name RespawnPoint
extends Node2D


@export var activation_channel: StringName

@onready var spawn_points: Node2D = $SpawnPoints


func _ready() -> void:
	EventManager.programmable_activated.connect(
		_on_programmable_activated
	)


func _on_programmable_activated(
	channel: StringName
) -> void:
	if channel != activation_channel:
		return

	EventManager.respawn_requested.emit(
		get_spawn_positions()
	)


func get_spawn_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []

	for child in spawn_points.get_children():
		var marker := child as Marker2D

		if marker == null:
			continue

		positions.append(marker.global_position)

	return positions
