class_name AttackComponent
extends Area2D

@export var entity: CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var follow_direction = sign(body.position.x - entity.position.x)
		entity.direction = follow_direction * abs(entity.direction)
		entity.is_attacking = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		entity.is_attacking = false
