class_name PlayerStateMachine
extends Node

@export var entity: CharacterBody2D
var states: Dictionary = {}
@export var initial_state: PlayerState
var current_state: PlayerState

func _ready() -> void:
	# register all child states
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.state_machine = self

	# start initial state
	if initial_state:
		change_state(initial_state.name.to_lower())

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

	var new_state: PlayerState = states[key]

	if new_state == current_state:
		return

	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
