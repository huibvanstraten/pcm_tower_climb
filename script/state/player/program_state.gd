class_name ProgrammingState
extends State

@export var move_component: MoveComponent
var is_finished: bool = false

func _ready() -> void:
	EventManager.programming_finished.connect(_on_programming_finished)

func enter() -> void:
	super()

	EventManager.programming_started.emit(entity)
	move_component.accute_stop()

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	# pressing interact during programming stops it
	if command.interact_pressed:
		EventManager.programming_cancelled.emit(entity)
		state_machine.change_state("Idle")

func update(delta: float) -> void:
	if is_finished:
		state_machine.change_state("Idle")

func physics_update(delta: float) -> void:
	pass

func _on_programming_finished(player: Player) -> void:
	is_finished = true
