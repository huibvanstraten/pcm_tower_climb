class_name FallState
extends State

@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent
var direction = 1

func enter() -> void:
	super()

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	direction = command.move_direction
	if command.move_direction != 0.0:
		flip_component.update_facing(direction)

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	physics_component.apply_gravity(delta)
	
	if direction != 0.0:
		move_component.move_in_air(delta, direction)
	else: move_component.apply_air_resistance(delta)
	
	if entity.is_on_floor():
		state_machine.change_state("Idle")
