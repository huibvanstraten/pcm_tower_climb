class_name MoveState
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

	if command.interact_pressed:
		state_machine.change_state("Program")

	if command.jump_pressed:
		state_machine.change_state("Jump")

func update(delta: float) -> void:
	var player: Player = entity as Player
	if player == null:
		return
	if player.is_hit:
		state_machine.change_state("Hit")


func physics_update(delta: float) -> void:
	physics_component.apply_gravity(delta)
	if direction != 0:
		move_component.move(delta, direction)
	else:
		move_component.stop(delta)

	if not entity.is_on_floor():
		state_machine.change_state("Fall")

	if entity.velocity.x == 0.0:
		# TODO: check if/when we need stop/halt
		state_machine.change_state("Idle")
