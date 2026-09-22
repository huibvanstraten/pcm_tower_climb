extends Node


var state: GameState.Type = GameState.Type.START_SCREEN
var input_contexts := InputContextStack.new()


func start() -> void:
	change_state(GameState.Type.START_SCREEN, true)


func change_state(
	next_state: GameState.Type,
	force: bool = false
) -> void:
	if state == next_state and not force:
		return

	state = next_state
	set_input_context()

	EventManager.state_changed.emit(state)


func set_input_context() -> void:
	match state:
		GameState.Type.START_SCREEN:
			input_contexts.set_context(InputContext.Type.MAIN_MENU)

		GameState.Type.PLAYER_SELECT:
			input_contexts.set_context(InputContext.Type.PLAYER_SELECT)

		GameState.Type.GAMEPLAY:
			input_contexts.set_context(InputContext.Type.GAMEPLAY)
