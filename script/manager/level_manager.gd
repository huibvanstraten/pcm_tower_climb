extends Node2D

var levels: Array[LevelData]

var mainScene: Node2D = null
var loadedLevel: Level = null

func _ready():
	print("manager ready")
	

func unload_level():
	if is_instance_valid(loadedLevel):
		loadedLevel.queue_free()
		
	loadedLevel = null
	
func load_level(levelId: int):
	print("loading?")
	push_warning("loading level: %s" % levelId)
	unload_level()
	
	var levelData = get_level_data_by_id(levelId)
	
	if not levelData:
		push_error("no level available")
		return
		
	var levelPath = levelData.levelPath
	var levelRes = load(levelPath)
	
	if levelRes:
		loadedLevel = levelRes.instantiate()
		mainScene.add_child(loadedLevel)

func get_level_data_by_id(levelId: int) -> LevelData:
	var levelToReturn: LevelData = null
	
	for level in levels:
		if level.levelId == levelId:
			levelToReturn = level
	
	return levelToReturn
		
func get_current_level():
	if loadedLevel != null:
		return loadedLevel
	else: 
		return get_tree().current_scene

func get_current_area() -> Area:
	var areas = get_current_level().get_node("Areas")
	var areaId = get_current_level().currentAreaId
	
	var currentArea: Area
	for i in areas.get_children():
		if (i as Area).areaId == areaId:
			currentArea = i as Area
	
	return currentArea

func get_level_boundaries() -> Array[StaticBody2D]:
	var area = get_current_area()
	
	var boundaries: Array[StaticBody2D] 
	for i in area.areaBoundaries.get_children():
		boundaries.append(i as StaticBody2D)
		
	return boundaries
