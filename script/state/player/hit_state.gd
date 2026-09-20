class_name HitState
extends State

@export var physics_component: PhysicsComponent
var command = PlayerCommand.new()

func enter() -> void:
	super()

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	self.command = command

func physics_update(delta: float) -> void:
	pass
