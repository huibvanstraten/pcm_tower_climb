extends Control


func _ready() -> void:
	EventManager.state_changed.connect(_on_game_state_changed)
	_on_game_state_changed(GameFlowManager.state)


func _on_game_state_changed(state: GameState.Type) -> void:
	visible = state == GameState.Type.START_SCREEN


func _input(event: InputEvent) -> void:
	if GameFlowManager.state != GameState.Type.START_SCREEN:
		return
		
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
	
	get_viewport().set_input_as_handled()

	GameFlowManager.change_state.call_deferred(
		GameState.Type.PLAYER_SELECT
)
