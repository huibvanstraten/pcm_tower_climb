class_name BounceBox
extends BounceComponent


@export_group("Impact Boost")
@export var fall_velocity_multiplier: float = 0.5
@export var max_fall_boost: float = 200.0


func get_bounce_strength(
	receiver: BounceReceiverComponent
) -> float:
	var fall_speed = \
		receiver.physics_component.get_fall_speed()

	var fall_boost = min(
		fall_speed * fall_velocity_multiplier,
		max_fall_boost
	)

	var strength = bounce_strength + fall_boost

	print(
		"BOUNCE BOX: fall_speed=", fall_speed,
		" boost=", fall_boost,
		" strength=", strength
	)

	return strength
