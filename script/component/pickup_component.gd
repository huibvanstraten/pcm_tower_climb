class_name PickupComponent
extends Node


@export var player: Player


func _on_area_entered(area: Area2D) -> void:
	var pickup := area as Pickup

	if pickup == null:
		return
	print("componentttt")
	pickup.collect(player)
