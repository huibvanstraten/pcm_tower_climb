class_name FragmentScatterComponent
extends Node


@export var player: Player
@export var hurt_component: HurtComponent


func _ready() -> void:
	hurt_component.hit_received.connect(
		_on_hit_received
	)


func _on_hit_received(hit: Hit) -> void:
	if hit.fragment_scatter <= 0:
		return

	scatter(hit.fragment_scatter)


func scatter(amount: int) -> int:
	if amount <= 0:
		return 0

	if player.session == null:
		return 0

	var removed := player.session.progress.remove_fragments(
		amount
	)

	if removed == 0:
		return 0

	FragmentSpawnManager.spawn_fragments(
		removed,
		player.global_position
	)

	return removed
