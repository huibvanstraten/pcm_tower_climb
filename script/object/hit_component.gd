class_name HitComponent
extends Area2D

@export var source: Entity

@export var knockbackStrength: Vector2 = Vector2(250.0, 300.0)


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	var hurtbox := area as HurtComponent

	if hurtbox == null:
		return
	
	if source != null and hurtbox.player == source:
		return

	var direction := Vector2(
		sign(hurtbox.global_position.x - global_position.x),
		0.0
	)

	var hit := Hit.new(
		direction,
		knockbackStrength,
		source
	)

	hurtbox.receive_hit(hit)
