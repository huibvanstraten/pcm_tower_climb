class_name Hit
extends RefCounted

enum Kind {
	NORMAL,
	FRIENDLY_FIRE,
}

var direction: Vector2
var knockback: Vector2
var source: Entity
var kind: Kind = Kind.NORMAL


func _init(
	hit_direction: Vector2,
	hit_knockback: Vector2,
	hit_source: Entity = null
) -> void:
	direction = hit_direction.normalized()
	knockback = hit_knockback
	source = hit_source
