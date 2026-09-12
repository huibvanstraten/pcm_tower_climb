class_name DebugInputSource
extends PlayerInputSource


var elapsed := 0.0
var should_jump := false


func _physics_process(delta: float) -> void:
	elapsed += delta

	if elapsed >= 1.0:
		elapsed = 0.0
		should_jump = true


func get_command() -> PlayerCommand:
	var command := PlayerCommand.new()

	if should_jump:
		command.jump_pressed = true
		command.jump_held = true
		should_jump = false

	return command
