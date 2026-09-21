class_name MoveState
extends State

@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent
var command = PlayerCommand.new()

func enter() -> void:
	super()

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	self.command = command

func physics_update(delta: float) -> void:
	physics_component.apply_gravity(delta)
	move_component.move(delta, command.move_direction)

	if command.jump_pressed:
		state_machine.change_state("Jump")
	elif command.interact_pressed:
		state_machine.change_state("Program")
	elif entity.velocity.x == 0.0:
		state_machine.change_state("Idle")
