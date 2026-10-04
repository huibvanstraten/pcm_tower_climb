class_name BounceReceiverComponent
extends Area2D


@export var jump_component: JumpComponent
@export var physics_component: PhysicsComponent

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	var bounce_component := area as BounceComponent

	if bounce_component == null:
		return

	var strength := bounce_component.get_bounce_strength(self)

	jump_component.bounce(strength)
