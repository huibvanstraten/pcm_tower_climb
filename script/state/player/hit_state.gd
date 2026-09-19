class_name HitState
extends PlayerState

var hit_data: Hit
var hit_animation_finished: bool = false


func initialize() -> void:
	super()

func set_hit(hit: Hit) -> void:
	hit_data = hit

func enter() -> void:
	super()

	hit_animation_finished = false

	if hit_data == null:
		return

	player.physics_component.apply_knockback(
		hit_data.direction,
		hit_data.knockback
	)

	animation_player.play(&"hit")
	

func physics_update(
	delta: float,
	_command: PlayerCommand
) -> PlayerTransition.Type:
	player.physics_component.apply_gravity(delta)

	if not hit_animation_finished:
		return PlayerTransition.Type.NONE

	if player.is_on_floor():
		return PlayerTransition.Type.IDLE

	return PlayerTransition.Type.FALL


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("FINISHED")
	if anim_name != &"hit":
		return

	hit_animation_finished = true
