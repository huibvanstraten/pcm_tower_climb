class_name ControllerInputSource
extends PlayerInputSource

@export var move_left_action: StringName
@export var move_right_action: StringName
@export var jump_action: StringName
@export var interact_action: StringName

var move_left_strength := 0.0
var move_right_strength := 0.0

var jump_pressed := false
var jump_held := false

var interact_pressed := false


func _ready() -> void:
	print("ControllerInputSource ready: ", get_path())


func _input(event: InputEvent) -> void:
	if not event_belongs_to_device(event):
		return

	_update_move_input(event)
	_update_jump_input(event)
	_update_interact_input(event)


func get_command(
	_device: PlayerInputDevice
) -> PlayerCommand:
	var command := PlayerCommand.new()

	command.move_direction = (
		move_right_strength
		- move_left_strength
	)

	command.jump_pressed = jump_pressed
	command.jump_held = jump_held

	command.interact_pressed = interact_pressed

	jump_pressed = false
	interact_pressed = false

	return command


func _update_move_input(event: InputEvent) -> void:
	if move_left_action != &"" and event.is_action(move_left_action):
		move_left_strength = event.get_action_strength(
			move_left_action
		)

	if move_right_action != &"" and event.is_action(move_right_action):
		move_right_strength = event.get_action_strength(
			move_right_action
		)
		

func _update_jump_input(event: InputEvent) -> void:
	if jump_action == &"":
		return

	if event.is_action_pressed(jump_action):
		print("jump pressed")
		jump_pressed = true
		jump_held = true

	if event.is_action_released(jump_action):
		jump_held = false


func _update_interact_input(event: InputEvent) -> void:
	if interact_action == &"":
		return

	if event.is_action_pressed(interact_action):
		interact_pressed = true
		
		
func event_belongs_to_device(event: InputEvent) -> bool:
	if input_device == null:
		return false

	match input_device.type:
		PlayerInputDevice.Type.KEYBOARD:
			return event is InputEventKey

		PlayerInputDevice.Type.JOYPAD:
			return (
				(event is InputEventJoypadButton
				or event is InputEventJoypadMotion)
				and event.device == input_device.device_id
			)

	return false
