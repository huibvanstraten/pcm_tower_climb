class_name Main
extends Node

@export var availableLevels: Array[LevelData]

@onready var levelContainer = $LevelContainer
@onready var playerContainer: Node = $PlayerContainer


func _ready():
	EventManager.connect("level", load_level)

	LevelManager.mainScene = levelContainer
	LevelManager.levels = availableLevels
	
	SpawnManager.player_container = playerContainer

	MusicManager.stream = load("res://asset/audio/music/Bzzt bzzt mf 3 full.wav")
	MusicManager.play()
	
	EventManager.emit_signal("level", 1)

func load_level(levelId: int):
	LevelManager.load_level(levelId)

	var level = LevelManager.get_current_level()

	for player_id in [1, 2]:
		var position = level.get_player_start_position(player_id)

		if SpawnManager.get_player(player_id) == null:
			SpawnManager.spawn_player(player_id, position)
		else:
			SpawnManager.position_player(player_id, position)
