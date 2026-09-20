class_name JumpState
extends State

@export var jump_component: JumpComponent
@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent
var command = PlayerCommand.new()

func enter() -> void:
	super()
	jump_component.jump()

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	self.command = command

func physics_update(delta: float) -> void:
	physics_component.apply_gravity(delta)

	if entity.velocity.y > 0.0:
		state_machine.change_state("Fall")
