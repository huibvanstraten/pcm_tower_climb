class_name PickupComponent
extends Node


@export var player: Player


func _on_area_entered(area: Area2D) -> void:
	print(
		"PICKUP COMPONENT detected: ",
		area,
		" type=",
		area.get_class()
	)

	var pickup_area := area as PickupArea

	if pickup_area == null:
		print("NOT A PICKUP AREA")
		return

	if pickup_area.pickup == null:
		print("PICKUP AREA HAS NO PICKUP")
		return

	print("COLLECTING: ", pickup_area.pickup)

	pickup_area.pickup.collect(player)
