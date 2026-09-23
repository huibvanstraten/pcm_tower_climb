class_name Enemy
extends Entity

@export var initial_direction: float = 1.0
var direction: float
var hit: Hit = null
var is_attacking = false

func _ready() -> void:
	direction = initial_direction

func is_hit() -> bool:
	if hit:
		return true
	else: 
		return false


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("start attacking...", body.name)
	if body is Player:
		var follow_direction = sign(body.position.x - self.position.x)
		direction = follow_direction * abs(self.direction)
		is_attacking = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("stop attacking...", body.name)
	is_attacking = false
