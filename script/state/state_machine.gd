class_name StateMachine
extends Node

@export var character: CharacterBody2D = null
@export var initialState: State = null

var currentState: State = null
var previousState: State = null


func _ready():
	for child in get_children():
		var state := child as State

		if state != null:
			state.initialize()

	changeState(initialState)


func changeState(nextState: State):
	if nextState == null:
		return

	if nextState == currentState:
		return

	previousState = currentState

	if currentState != null:
		currentState.exit()

	currentState = nextState
	currentState.enter()
