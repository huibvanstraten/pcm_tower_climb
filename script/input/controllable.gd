class_name Controllable
extends RefCounted


static func is_controllable(target: Node) -> bool:
	return target.has_method("handle_command")
