class_name Level
extends Node

@export var levelId: int
@export var startAreaId: int = 1
@export var startPosition: Marker2D = null

var levelData: LevelData
var currentAreaId: int


func _ready() -> void:
	currentAreaId = startAreaId

	var area = get_current_area()

	if area == null:
		push_error("Could not find start area: %s" % startAreaId)
		return

	area.activate()
	

func get_area(area_id: int) -> Area:
	for area in $Areas.get_children():
		if area.areaId == area_id:
			return area

	return null
	
	
func get_current_area() -> Area:
	return get_area(currentAreaId)

func set_current_area(areaId: int):
	currentAreaId = areaId


func transition_to_area(area_id: int) -> void:
	if area_id == currentAreaId:
		return

	var next_area := get_area(area_id)

	if next_area == null:
		push_error("Could not find area: %s" % area_id)
		return

	var current_area := get_current_area()

	if current_area != null:
		current_area.deactivate()

	currentAreaId = area_id
	next_area.activate()
	

func get_player_start_position(player_id: int) -> Vector2:
	var marker_name := "Start_%s" % player_id

	var marker := get_node_or_null(
		"SpawnPoints/%s" % marker_name
	) as Marker2D

	if marker == null:
		push_error("No spawn position found for player %s" % player_id)
		return Vector2.ZERO

	return marker.global_position


func _on_game_paused(isPaused: bool):
	get_tree().paused = isPaused
