class_name ProgrammingState 
extends PlayerState
var programming_finished: bool = false

const NAME := "Program"

func _ready() -> void:
	EventManager.programming_finished.connect(_finish_programming)

func enter() -> void:
	move_component.accute_stop()
	EventManager.programming_started.emit(entity)
	
	super()


func exit() -> void:
	programming_finished = false

	super()

func physics_update(delta: float) -> String:
	
	# to be evaluated: get reaction to hit
	var reaction := get_hit_transition()
	if reaction != "None":
		EventManager.programming_cancelled.emit(entity)
		return reaction

	if entity.velocity.y > 0.0:
		return FallState.NAME

	if programming_finished:
		return IdleState.NAME

	if entity.command.interact_pressed:
		EventManager.programming_cancelled.emit(entity)
		return IdleState.NAME

	return "None"

func _finish_programming(player: Player) -> void:
	print("Finished programming received", player.name)
	if player == entity:
		programming_finished = true
