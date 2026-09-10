class_name Main
extends Node

@export var availableLevels: Array[LevelData]

@onready var levelContainer = $LevelContainer

func _ready():
	EventManager.connect("level", load_level)

	LevelManager.mainScene = levelContainer
	LevelManager.levels = availableLevels
	#MusicManager.stream = load("res://assets/audio/music/Extinction full.wav")
	#MusicManager.play()
	EventManager.emit_signal("level", 1)




func load_level(levelId: int):
	LevelManager.load_level(levelId)
	_deactivate()

func _deactivate():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	queue_free()
