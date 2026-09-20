class_name IdleState
extends State

@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent
var command = PlayerCommand.new()

func enter() -> void:
	super()
	physics_component.halt_horizontal()

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	self.command = command

func physics_update(delta: float) -> void:
	physics_component.apply_gravity(delta)

	if entity.velocity.y > 0.0:
		state_machine.change_state("Fall")
	elif command.move_direction != 0.0:
		state_machine.change_state("Move")
	elif command.jump_pressed:
		state_machine.change_state("Jump")
	elif command.interact_pressed:
		state_machine.change_state("Program")
