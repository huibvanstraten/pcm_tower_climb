class_name StateMachine
extends Node

@export var initial_state: State
@export var entity: CharacterBody2D
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	# register all child states
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self
	print(get_children())

	# start initial state
	if initial_state:
		change_state(initial_state.name.to_lower())

# player input commands received from the PlayerInputSession
func handle_command(command: PlayerCommand) -> void:
	current_state.handle_command(command)

# on each frame tick
func _process(delta: float) -> void:
	pass

# one each physics frame tick
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
	entity.move_and_slide()

func change_state(to_state: String) -> void:
	var key := to_state.to_lower()

	if not states.has(key):
		push_error("to_state '{0}' is not defined".format([to_state]))
		return

	var new_state: State = states[key]

	if new_state == current_state:
		return

	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
