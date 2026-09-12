class_name PlayerStateMachine
extends StateMachine

@export var idle_state: PlayerState
@export var run_state: PlayerState
@export var jump_state: PlayerState
@export var fall_state: PlayerState


func _ready():
	super()
	EventManager.connect("freeze_player", _freeze_state_machine)


func physics_update(
	delta: float,
	command: PlayerCommand
) -> void:
	var player_state := currentState as PlayerState

	if player_state == null:
		return

	var transition := player_state.physics_update(delta, command)

	match transition:
		PlayerTransition.Type.NONE:
			pass

		PlayerTransition.Type.IDLE:
			changeState(idle_state)

		PlayerTransition.Type.RUN:
			changeState(run_state)

		PlayerTransition.Type.JUMP:
			changeState(jump_state)

		PlayerTransition.Type.FALL:
			changeState(fall_state)


func can_move() -> bool:
	var playerState := currentState as PlayerState

	if playerState == null:
		return false

	return playerState.canMove


func _freeze_state_machine(freeze: bool):
	if freeze:
		changeState(initialState)
