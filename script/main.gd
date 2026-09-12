class_name Main
extends Node


@export var availableLevels: Array[LevelData]

@onready var level_container: Node = $LevelContainer
@onready var player_container: Node = $PlayerContainer
@onready var input_session_container: Node = $PlayerInputSessionContainer


func _ready() -> void:
	EventManager.connect("level", load_level)

	LevelManager.mainScene = level_container
	LevelManager.levels = availableLevels

	SpawnManager.player_container = player_container

	MusicManager.stream = load(
		"res://asset/audio/music/Bzzt bzzt mf 3 full.wav"
	)
	MusicManager.play()

	EventManager.emit_signal("level", 1)


func load_level(level_id: int) -> void:
	LevelManager.load_level(level_id)

	var level = LevelManager.get_current_level()

	for player_id in [1, 2]:
		var position: Vector2 = level.get_player_start_position(player_id)
		ensure_player(player_id, position)


func ensure_player(
	player_id: int,
	position: Vector2
) -> void:
	var player := SpawnManager.get_player(player_id)

	if player == null:
		player = SpawnManager.spawn_player(
			player_id,
			position
		)

		get_input_session(player_id).set_control_target(player)
		
	else:
		SpawnManager.position_player(
			player_id,
			position
		)


func get_input_session(
	player_id: int
) -> PlayerInputSession:
	return input_session_container.get_node(
		"PlayerInputSession%d" % player_id
	) as PlayerInputSession
