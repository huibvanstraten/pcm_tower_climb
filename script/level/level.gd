class_name Level
extends Node

@export var levelId: int
@export var startAreaId: int = 1
@export var startPosition: Marker2D = null

var levelData: LevelData
var player: Player
var currentAreaId: int

func _enter_tree():
	currentAreaId = startAreaId

func _ready():
	levelData = LevelManager.get_level_data_by_id(levelId)

func set_current_area(areaId: int):
	currentAreaId = areaId


func get_player_start_position(player_id: int) -> Vector2:
	var marker_name := "Start_%s" % player_id

	var marker := get_node_or_null(
		"SpawnPoints/%s" % marker_name
	) as Marker2D

	if marker == null:
		push_error("No spawn position found for player %s" % player_id)
		return Vector2.ZERO

	return marker.global_position

func _on_player_died(player: Player):
	print("Player %s died" % player.player_id)

func _on_game_paused(isPaused: bool):
	get_tree().paused = isPaused
