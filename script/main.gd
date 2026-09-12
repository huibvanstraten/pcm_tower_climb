class_name Main
extends Node


@export var availableLevels: Array[LevelData]

@onready var level_container: Node = $LevelContainer
@onready var player_container: Node = $PlayerContainer
@onready var input_session_container: Node = $PlayerInputSessionContainer


func _input(event: InputEvent) -> void:
	var device := PlayerInputDevice.from_event(event)

	if device == null:
		return

	if is_device_assigned(device):
		return

	if not event.is_action_pressed("jump"):
		return

	join_device(device)
	

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

	position_joined_players()


func get_available_input_session() -> PlayerInputSession:
	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if not session.is_joined():
			return session

	return null
	
	
func activate_session_player(session: PlayerInputSession) -> void:
	var level = LevelManager.get_current_level()

	var spawn_position: Vector2 = level.get_player_start_position(
		session.player_slot
	)

	var player := SpawnManager.get_player(session.player_slot)

	if player == null:
		player = SpawnManager.spawn_player(
			session.player_slot,
			spawn_position
		)
	else:
		SpawnManager.position_player(
			session.player_slot,
			spawn_position
		)

	session.set_control_target(player)
	
	
func is_device_assigned(device: PlayerInputDevice) -> bool:
	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if not session.is_joined():
			continue

		if session.input_device.matches(device):
			return true

	return false
	
	
func join_device(device: PlayerInputDevice) -> void:
	var session := get_available_input_session()

	if session == null:
		print("JOIN REQUEST REJECTED: no available input session")
		return

	session.assign_device(device)
	activate_session_player(session)
	
	
func position_joined_players() -> void:
	var level = LevelManager.get_current_level()

	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if session.input_device == null:
			continue

		var player := SpawnManager.get_player(session.player_slot)

		if player == null:
			continue

		var spawn_position: Vector2 = level.get_player_start_position(
			session.player_slot
		)

		SpawnManager.position_player(
			session.player_slot,
			spawn_position
		)
