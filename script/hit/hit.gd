class_name Hit
extends RefCounted

var direction: Vector2
var knockback: Vector2


func _init(
	hit_direction: Vector2,
	hit_knockback: Vector2
) -> void:
	direction = hit_direction.normalized()
	knockback = hit_knockback
