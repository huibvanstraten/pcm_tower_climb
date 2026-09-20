class_name ProgrammingState
extends State

@export var move_component: MoveComponent
var command = PlayerCommand.new()

func enter() -> void:
	super()
	move_component.accute_stop()

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	self.command = command

func physics_update(delta: float) -> void:
	if command.interact_pressed:
		state_machine.change_state("Idle")
