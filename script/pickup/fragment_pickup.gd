class_name FragmentPickup
extends Pickup


@export_range(1, 100) var amount: int = 1


func collect(player: Player) -> bool:
	if player.session == null:
		push_error(
			"FragmentPickup collected by Player without session"
		)
		return false

	print("picking up")
	player.session.progress.add_fragments(amount)

	queue_free()

	return true
