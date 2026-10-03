class_name FragmentPickup
extends Pickup


@export var amount: int = 1

@export_group("Dropped")
@export var collection_delay := 0.5
@export var dropped_lifetime := 8.0
@export var flicker_duration := 2.0
@export var flicker_interval := 0.1

@onready var body: RigidBody2D = $Body
@onready var collection_area: PickupArea = \
	$Body/CollectionArea
@onready var sprite: AnimatedSprite2D = \
	$Body/AnimatedSprite2D

var collection_locked := false


func collect(player: Player) -> bool:
	if collection_locked:
		return false

	if player.session == null:
		return false

	player.session.progress.add_fragments(amount)
	queue_free()

	return true


func configure_as_dropped(
	initial_velocity: Vector2
) -> void:
	body.linear_velocity = initial_velocity

	_lock_collection()
	_start_dropped_lifetime()


func _lock_collection() -> void:
	if collection_delay <= 0.0:
		return

	collection_locked = true

	await get_tree().create_timer(
		collection_delay
	).timeout

	if not is_inside_tree():
		return

	collection_locked = false


func _start_dropped_lifetime() -> void:
	if dropped_lifetime <= 0.0:
		return

	var normal_duration := maxf(
		dropped_lifetime - flicker_duration,
		0.0
	)

	if normal_duration > 0.0:
		await get_tree().create_timer(
			normal_duration
		).timeout

	if not is_inside_tree():
		return

	await _flicker()

	if not is_inside_tree():
		return

	queue_free()


func _flicker() -> void:
	var remaining := minf(
		flicker_duration,
		dropped_lifetime
	)

	while remaining > 0.0:
		sprite.visible = not sprite.visible

		var interval := minf(
			flicker_interval,
			remaining
		)

		await get_tree().create_timer(
			interval
		).timeout

		if not is_inside_tree():
			return

		remaining -= interval

	sprite.visible = true
