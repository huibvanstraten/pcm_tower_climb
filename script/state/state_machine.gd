class_name StateMachine
extends Node

@export var character: CharacterBody2D = null
@export var initialState: State = null

var currentState: State = null
var previousState: State = null


func _ready() -> void:
	for child in get_children():
		var state := child as State

		if state != null:
			state.initialize()


func start() -> void:
	changeState(initialState)


func changeState(nextState: State) -> void:
	if nextState == null:
		return

	if nextState == currentState:
		return

	previousState = currentState

	if currentState != null:
		currentState.exit()

	currentState = nextState
	currentState.enter()
