class_name Main
extends Node

@export var player_input_session_scene: PackedScene
@export var availableLevels: Array[LevelData]

@onready var level_container: Node = $LevelContainer
@onready var player_container: Node = $PlayerContainer
@onready var input_session_container: Node = $PlayerInputSessionContainer

const MAX_PLAYERS := 4


func _ready() -> void:
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


func _input(event: InputEvent) -> void:
	match GameFlowManager.state:
		GameState.Type.START_SCREEN:
			handle_start_screen_input(event)

		GameState.Type.GAMEPLAY:
			handle_gameplay_input(event)



func _on_game_state_changed(
	state: GameState.Type
) -> void:
	if state == GameState.Type.GAMEPLAY:
		_start_gameplay()


func _start_gameplay() -> void:
	LevelManager.load_level(1)

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

func handle_start_screen_input(event: InputEvent) -> void:
	if not event.is_action_pressed("start"):
		return

	var device = PlayerInputDevice.from_event(event)

	if device == null:
		return

	if PlayerSessionManager.get_session_for_device(device) != null:
		return

	var session = PlayerSessionManager.join_device(device)

	if session == null:
		return

	GameFlowManager.change_state(
		GameState.Type.PLAYER_SELECT
	)


func handle_gameplay_input(event: InputEvent) -> void:
	var device := PlayerInputDevice.from_event(event)

	if device == null:
		return

	if not event.is_action_pressed("jump"):
		return

	var session = PlayerSessionManager.get_session_for_device(device)

	if session == null:
		PlayerSessionManager.join_device(device)
		return

	if session.state == PlayerInputSession.State.READY:
		PlayerLifecycleManager.activate_session_player(session)
	

func get_players() -> Array[Player]:
	var players: Array[Player] = []

	for child in player_container.get_children():
		if child is Player:
			players.append(child)

	return players


func load_level(level_id: int) -> void:
	LevelManager.load_level(level_id)

	PlayerLifecycleManager.position_joined_players()
