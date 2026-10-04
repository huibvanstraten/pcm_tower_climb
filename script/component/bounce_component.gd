class_name BounceComponent
extends Area2D


@export var bounce_strength: float = 300.0


func get_bounce_strength(
	_receiver: BounceReceiverComponent
) -> float:
	return bounce_strength
