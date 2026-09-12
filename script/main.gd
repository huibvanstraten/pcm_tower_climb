class_name Main
extends Node

@export var player_input_session_scene: PackedScene
@export var availableLevels: Array[LevelData]

@onready var level_container: Node = $LevelContainer
@onready var player_container: Node = $PlayerContainer
@onready var input_session_container: Node = $PlayerInputSessionContainer

const MAX_PLAYERS := 4

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

		if session.input_device.matches(device):
			return true

	return false
	
	
func join_device(device: PlayerInputDevice) -> void:
	var player_slot := get_available_player_slot()

	if player_slot == -1:
		print("JOIN REQUEST REJECTED: no available player slot")
		return

	var session := create_input_session(
		player_slot,
		device
	)

	activate_session_player(session)

	print(
		"DEVICE JOINED: ",
		PlayerInputDevice.Type.keys()[device.type],
		" ",
		device.device_id,
		" -> player slot ",
		player_slot
	)
	

func create_input_session(
	player_slot: int,
	device: PlayerInputDevice
) -> PlayerInputSession:
	var session := player_input_session_scene.instantiate() as PlayerInputSession

	session.player_slot = player_slot
	session.name = "PlayerInputSession%s" % player_slot

	input_session_container.add_child(session)

	session.assign_device(device)

	return session


func get_available_player_slot() -> int:
	for player_slot in range(1, MAX_PLAYERS + 1):
		if not is_player_slot_used(player_slot):
			return player_slot

	return -1
	
	
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
	

func is_player_slot_used(player_slot: int) -> bool:
	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if session.player_slot == player_slot:
			return true

	return false
