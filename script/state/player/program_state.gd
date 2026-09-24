class_name ProgrammingState 
extends PlayerState
var programming_finished: bool = false

const NAME := "Program"

func _ready() -> void:
	EventManager.programming_finished.connect(_finish_programming)

func enter() -> void:
	super()
	move_component.accute_stop()
	EventManager.programming_started.emit(entity)

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	if entity.is_hit():
		return HitState.NAME
	if programming_finished:
		programming_finished = false
		return IdleState.NAME
	if entity.command.interact_pressed:
		EventManager.programming_cancelled.emit(entity)
		return IdleState.NAME
	return "None"

func _finish_programming(player: Player) -> void:
	print("Finished programming received", player.name)
	if player == entity:
		programming_finished = true
