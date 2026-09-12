class_name PlayerInputDevice
extends RefCounted


enum Type {
	KEYBOARD,
	JOYPAD,
}

var type: Type
var device_id: int


func _init(
	device_type: Type,
	id: int = -1
) -> void:
	type = device_type
	device_id = id


static func from_event(event: InputEvent) -> PlayerInputDevice:
	if event is InputEventKey:
		return PlayerInputDevice.new(
			PlayerInputDevice.Type.KEYBOARD
		)

	if (event is InputEventJoypadButton or event is InputEventJoypadMotion):	
		return PlayerInputDevice.new(
			PlayerInputDevice.Type.JOYPAD,
			event.device
		)
	
	return null


func matches(other: PlayerInputDevice) -> bool:
	if other == null:
		return false

	return (
		type == other.type
		and device_id == other.device_id
	)
