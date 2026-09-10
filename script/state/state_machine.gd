class_name StateMachine
extends Node

@export var character: CharacterBody2D = null
@export var initialState: State = null 

var currentState: State = null
var previousState: State = null

func _ready():
	var states = get_children()
	for state in states:
		var stateNode: State = state as State
		stateNode.initialize()
	
	currentState = initialState
	changeState(initialState)
	
func changeState(nextState: State):
	previousState = currentState
	currentState.exit()
	currentState = nextState
	currentState.enter()
