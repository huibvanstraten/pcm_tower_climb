class_name Main
extends Node


@export var availableLevels: Array[LevelData]

@onready var level_container: Node = $LevelContainer
@onready var player_container: Node = $PlayerContainer
@onready var input_session_container: Node = $PlayerInputSessionContainer


func _input(event: InputEvent) -> void:
	var discovered_device := PlayerInputDevice.from_event(event)

	if discovered_device == null:
		return

	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if session.input_device == null:
			continue

		if session.input_device.matches(discovered_device):
			print(
				"DEVICE ALREADY ASSIGNED: ",
				PlayerInputDevice.Type.keys()[discovered_device.type],
				" ",
				discovered_device.device_id
			)
			return

	print(
		"UNASSIGNED DEVICE: ",
		PlayerInputDevice.Type.keys()[discovered_device.type],
		" ",
		discovered_device.device_id
	)
	
	if not event.is_action_pressed("jump"):
		return

	var available_session := get_available_input_session()

	if available_session == null:
		print("JOIN REQUEST REJECTED: no available input session")
		return

	available_session.assign_device(discovered_device)

	print(
		"DEVICE JOINED: ",
		PlayerInputDevice.Type.keys()[discovered_device.type],
		" ",
		discovered_device.device_id,
		" -> ",
		available_session.name
	)

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
	

func get_available_input_session() -> PlayerInputSession:
	for child in input_session_container.get_children():
		var session := child as PlayerInputSession

		if session == null:
			continue

		if session.input_device == null:
			return session

	return null
