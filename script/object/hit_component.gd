class_name HitComponent
extends Area2D

# not implemented.
@export var pathFollow: PathFollow2D = null

# not implemented
@export var damage: float = 10.0

# not implemented
@export var removeBodyAtTouch: bool = false
@export var removeAttackBodyAtTouch: bool = false

@export var knockbackStrength: Vector2 = Vector2(250.0, 300.0)


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	var hurtbox := area as HurtComponent

	if hurtbox == null:
		return

	var direction := Vector2(
		sign(hurtbox.global_position.x - global_position.x),
		0.0
	)

	hurtbox.receive_hit(
		Hit.new(direction, knockbackStrength)
	)
