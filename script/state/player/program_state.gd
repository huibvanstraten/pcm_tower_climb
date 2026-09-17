class_name ProgrammingState
extends PlayerState


var is_finished: bool = false


func initialize() -> void:
	super()

	EventManager.programming_finished.connect(_on_programming_finished)


func enter() -> void:
	super()
	print("PROGRAM STATE")


	is_finished = false

	var player := character_body as Player

	if player == null:
		return
		
	EventManager.programming_started.emit(player)
	
	player.move_component.accute_stop()


func physics_update(
	_delta: float,
	command: PlayerCommand
) -> PlayerTransition.Type:
	if command.interact_pressed:
		EventManager.programming_cancelled.emit(character_body)
		return PlayerTransition.Type.IDLE

	if is_finished:
		return PlayerTransition.Type.IDLE

	return PlayerTransition.Type.NONE


func _on_programming_finished(player: Player) -> void:
	if player != character_body:
		return

	is_finished = true
