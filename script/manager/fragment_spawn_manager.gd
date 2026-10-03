extends Node


const FRAGMENT_PICKUP_SCENE := preload(
	"res://scene/object/fragment.tscn"
)

const DROP_SPAWN_OFFSET := Vector2(0.0, -12.0)

const MAX_HORIZONTAL_SPEED := 100.0
const MIN_VERTICAL_SPEED := 100.0
const MAX_VERTICAL_SPEED := 180.0
const HORIZONTAL_VARIATION := 35.0
const VERTICAL_VARIATION := 45.0
const SPAWN_VARIATION := Vector2(6.0, 4.0)

var level_container: Node2D


func set_level_container(container: Node2D) -> void:
	level_container = container


func clear_level_container() -> void:
	level_container = null


func spawn_fragments(
	amount: int,
	spawn_position: Vector2
) -> void:
	if amount <= 0:
		return

	if level_container == null:
		push_error(
			"Cannot spawn fragments: world container is not configured"
		)
		return

	for index in amount:
		var fragment := FRAGMENT_PICKUP_SCENE.instantiate() \
			as FragmentPickup

		level_container.add_child(fragment)

		fragment.global_position = (
			spawn_position
			+ DROP_SPAWN_OFFSET
			+ Vector2(
				randf_range(
					-SPAWN_VARIATION.x,
					SPAWN_VARIATION.x
				),
				randf_range(
					-SPAWN_VARIATION.y,
					SPAWN_VARIATION.y
				)
			)
		)

		fragment.configure_as_dropped(
			_get_scatter_velocity(
				index,
				amount
			)
		)


func _get_scatter_velocity(
	index: int,
	amount: int
) -> Vector2:
	if amount <= 1:
		return Vector2(
			randf_range(
				-HORIZONTAL_VARIATION,
				HORIZONTAL_VARIATION
			),
			-MAX_VERTICAL_SPEED
				+ randf_range(
					-VERTICAL_VARIATION,
					VERTICAL_VARIATION
				)
		)

	var t := float(index) / float(amount - 1)

	var horizontal_velocity := lerpf(
		-MAX_HORIZONTAL_SPEED,
		MAX_HORIZONTAL_SPEED,
		t
	)

	var center_distance = abs(
		t - 0.5
	) * 2.0

	var vertical_velocity := lerpf(
		MAX_VERTICAL_SPEED,
		MIN_VERTICAL_SPEED,
		center_distance
	)

	return Vector2(
		horizontal_velocity
			+ randf_range(
				-HORIZONTAL_VARIATION,
				HORIZONTAL_VARIATION
			),
		-vertical_velocity
			+ randf_range(
				-VERTICAL_VARIATION,
				VERTICAL_VARIATION
			)
	)
