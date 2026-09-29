class_name BounceReceiverComponent
extends Area2D

@export var jump_component: JumpComponent

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	print("BOUNCE RECEIVER ENTERED: ", area)

	var bounce_component := area as BounceComponent

	if bounce_component == null:
		return

	jump_component.bounce(
		bounce_component.bounce_strength
	)
