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
	player_slots[player_slot - 1].set_state(
		PlayerHUDSlot.State.READY
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


func _on_player_respawned(player: Player) -> void:
	player_slots[player.player_id - 1].set_state(
		PlayerHUDSlot.State.PLAYING
	)
