class_name JumpState
extends State

@export var jump_component: JumpComponent
@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent
var direction = 1

func enter() -> void:
	super()
	jump_component.jump()

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	direction = command.move_direction
	if command.move_direction != 0.0:
		flip_component.update_facing(direction)

	if command.jump_released:
		jump_component.stop_jump()

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	physics_component.apply_gravity(delta)
	move_component.move_in_air(delta, direction)

	if entity.is_on_ceiling():
		#TODO: check if/when we need stop jump
		jump_component.stop_jump()
		state_machine.change_state("Fall")

	if entity.velocity.y > 0.0:
		state_machine.change_state("Fall")
