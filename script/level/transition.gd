class_name Transition
extends Area2D

@export var transitionAreaId: int
@export var changeBackground: bool
@export var transitionDirection: Vector2

@onready var marker: Marker2D = $Marker2D

func _on_body_entered(body):
	if body is Player:
		body.global_position = marker.global_position
		body.physicsComponent.direction = transitionDirection
		EventManager.transition_to_area.emit(transitionAreaId)
		if changeBackground:
			EventManager.change_background.emit(transitionAreaId)
