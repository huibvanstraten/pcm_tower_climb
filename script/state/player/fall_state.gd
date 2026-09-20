class_name FallState
extends State

@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent
var command: PlayerCommand = PlayerCommand.new()

func enter() -> void:
	super()

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	self.command = command

func physics_update(delta: float) -> void:
	physics_component.apply_gravity(delta)
	move_component.move_in_air(delta, command.move_direction)

	if entity.is_on_floor():
		if command.move_direction != 0.0:
			state_machine.change_state("Move")
		else:
			state_machine.change_state("Idle")
