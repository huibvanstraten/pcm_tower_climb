class_name Player
extends Entity

@onready var state_machine: StateMachine = $StateMachine

var player_id: int
var is_hit = false

func _ready() -> void:
	pass

func handle_command(command: PlayerCommand) -> void:
	if command:
		state_machine.handle_command(command)
