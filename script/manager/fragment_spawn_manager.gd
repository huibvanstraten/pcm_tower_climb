extends Node


const FRAGMENT_PICKUP_SCENE := preload(
	"res://scene/object/fragment.tscn"
)

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
		fragment.global_position = spawn_position
