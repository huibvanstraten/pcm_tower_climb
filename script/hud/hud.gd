extends CanvasLayer


@onready var player_slots: Array[PlayerHUDSlot] = [
	$MarginContainer/HBoxContainer/PlayerHUDSlot1,
	$MarginContainer/HBoxContainer/PlayerHUDSlot2,
	$MarginContainer/HBoxContainer/PlayerHUDSlot3,
	$MarginContainer/HBoxContainer/PlayerHUDSlot4,
]


func _ready() -> void:
	EventManager.state_changed.connect(
		_on_game_state_changed
	)

	_on_game_state_changed(GameFlowManager.state)

	EventManager.player_session_joined.connect(
		_on_player_session_joined
	)
	
	EventManager.player_session_waiting.connect(
		_on_player_session_waiting
	)
	
	EventManager.player_joined.connect(
		_on_player_joined
	)
	
	EventManager.player_died.connect(
		_on_player_died
	)
	
	
	EventManager.player_respawned.connect(
		_on_player_respawned
	)


func _on_game_state_changed(state: GameState.Type) -> void:
	visible = state == GameState.Type.GAMEPLAY
	

func _on_player_session_joined(player_slot: int) -> void:
	var session := PlayerSessionManager.get_session(
		player_slot
	)

	if session == null:
		return

	_connect_progress(
		session
	)
	
	player_slots[player_slot - 1].set_state(
		PlayerHUDSlot.State.READY
	)


func _connect_progress(
	session: PlayerSession
) -> void:
	var callback := _on_fragments_changed.bind(
		session.player_slot
	)

	if session.progress.fragments_changed.is_connected(
		callback
	):
		return

	session.progress.fragments_changed.connect(
		callback
	)

	_on_fragments_changed(
		session.progress.fragments,
		session.player_slot
	)
	

func _on_fragments_changed(
	amount: int,
	player_slot: int
) -> void:
	var slot_index := player_slot - 1

	if slot_index < 0:
		return

	if slot_index >= player_slots.size():
		return

	player_slots[slot_index].set_fragments(
		amount
	)


func _on_player_session_waiting(player_slot: int) -> void:
	player_slots[player_slot - 1].set_state(
		PlayerHUDSlot.State.WAITING
	)
	
func _on_player_joined(player: Player) -> void:
	player_slots[player.player_id - 1].set_state(
		PlayerHUDSlot.State.PLAYING,
		player.player_id
	)
	

func _on_player_died(player: Player) -> void:
	player_slots[player.player_id - 1].set_state(
		PlayerHUDSlot.State.WAITING
	)


func _on_player_respawned(
	player: Player
) -> void:
	player_slots[player.player_id - 1].set_state(
		PlayerHUDSlot.State.PLAYING,
		player.player_id
	)
