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
var fragment_scatter: int


func _init(
	hit_direction: Vector2,
	hit_knockback: Vector2,
	hit_source: Entity = null,
	fragment_scatter_amount: int = 0
) -> void:
	direction = hit_direction.normalized()
	knockback = hit_knockback
	source = hit_source
	fragment_scatter = fragment_scatter_amount
