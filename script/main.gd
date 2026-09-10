class_name Main
extends Node

@export var availableLevels: Array[LevelData]

@onready var levelContainer = $LevelContainer

func _ready():
	EventManager.connect("level", load_level)

	LevelManager.mainScene = levelContainer
	LevelManager.levels = availableLevels
	MusicManager.stream = load("res://asset/audio/music/Bzzt bzzt mf 3 full.wav")
	MusicManager.play()
	EventManager.emit_signal("level", 1)

func load_level(levelId: int):
	LevelManager.load_level(levelId)
