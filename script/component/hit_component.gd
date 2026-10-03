class_name HitComponent
extends Area2D

@export var source: Entity

@export var knockbackStrength: Vector2 = Vector2(250.0, 300.0)

@export var fragment_scatter_amount: int


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
	
	print(fragment_scatter_amount)

	var hit := Hit.new(
		direction,
		knockbackStrength,
		source,
		fragment_scatter_amount
	)

	hurtbox.receive_hit(hit)
