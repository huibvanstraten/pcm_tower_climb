class_name Player
extends Entity

var player_id: int
var command: PlayerCommand = PlayerCommand.new()
var hit: Hit = null

func handle_command(command: PlayerCommand) -> void:
	if command:
		self.command = command

func is_hit() -> bool:
	if hit:
		return true
	else: 
		return false
