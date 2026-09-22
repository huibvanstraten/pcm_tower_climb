class_name Enemy
extends Entity

@export var initial_direction: float = 1.0
var direction: float
var hit: Hit = null
var is_attacking = false

func is_hit() -> bool:
	if hit:
		return true
	else: 
		return false
