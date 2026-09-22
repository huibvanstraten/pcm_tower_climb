extends Control


func _ready() -> void:
	EventManager.state_changed.connect(_on_game_state_changed)
	_on_game_state_changed(GameFlowManager.state)


func _on_game_state_changed(state: GameState.Type) -> void:
	visible = state == GameState.Type.START_SCREEN
