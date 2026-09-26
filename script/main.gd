class_name Main
extends Node

@export var player_input_session_scene: PackedScene
@export var availableLevels: Array[LevelData]
@export var character_roster: CharacterRoster

@onready var level_container: Node = $LevelContainer
@onready var player_container: Node = $PlayerContainer
@onready var input_session_container: Node = $PlayerInputSessionContainer

const MAX_PLAYERS := 4


func _ready() -> void:
	PlayerLifecycleManager.character_roster = character_roster
	PlayerSessionManager.character_roster = character_roster
	
	PlayerSessionManager.setup(
	player_input_session_scene,
	input_session_container
)
	
	EventManager.state_changed.connect(_on_game_state_changed)
	GameFlowManager.start()
	EventManager.level.connect(load_level)


	LevelManager.mainScene = level_container
	LevelManager.levels = availableLevels

	SpawnManager.player_container = player_container


func _on_game_state_changed(
	state: GameState.Type
) -> void:
	if state == GameState.Type.GAMEPLAY:
		_start_gameplay()


func _start_gameplay() -> void:
	LevelManager.load_level(3)

	var level = LevelManager.loadedLevel

	if level == null:
		push_error("Could not start gameplay: level not loaded")
		return

	for session in PlayerSessionManager.get_sessions():
		if not session.selection.confirmed:
			continue

		PlayerLifecycleManager.activate_session_player(
			session
		)


func get_players() -> Array[Player]:
	var players: Array[Player] = []

	for child in player_container.get_children():
		if child is Player:
			players.append(child)

	return players


func load_level(level_id: int) -> void:
	LevelManager.load_level(level_id)

	PlayerLifecycleManager.position_joined_players()
