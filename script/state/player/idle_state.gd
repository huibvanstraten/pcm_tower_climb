class_name IdleState
extends State

@export var physics_component: PhysicsComponent

func enter() -> void:
	super()

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	if command.move_direction != 0.0:
		state_machine.change_state("Move")

	if command.jump_pressed:
		state_machine.change_state("Jump")

	if command.interact_pressed:
		state_machine.change_state("Program")

func update(delta: float) -> void:
	var player: Player = entity as Player
	if player == null:
		return
	if player.is_hit:
		state_machine.change_state("Hit")

func physics_update(delta: float) -> void:
	physics_component.apply_gravity(delta)

	# must be a forced move (imposed by an entity other than the player)
	if entity.velocity.x > 0:
		state_machine.change_state("Move")

	# must be a forced move (imposed by an entity other than the player)
	if entity.velocity.y < 0:
		state_machine.change_state("Jump")

	# must be a forced move (imposed by an entity other than the player)
	if entity.velocity.y > 0:
		state_machine.change_state("Fall")
