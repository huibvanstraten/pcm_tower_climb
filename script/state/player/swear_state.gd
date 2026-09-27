class_name SwearState
extends PlayerState

const NAME := "Swear"

@export var hurt_component: HurtComponent

var swear_animation_finished: bool = false

func enter() -> void:
	hurt_component.accepts_friendly_fire = false

	entity.hit = null
	physics_component.reset_velocity()
	swear_animation_finished = false

	super()


func exit() -> void:
	hurt_component.accepts_friendly_fire = true
	super()


func physics_update(delta: float) -> String:
	physics_component.halt_horizontal()

	physics_component.apply_gravity(delta)
	
	# to be evaluated: get reaction to hit
	var reaction := get_hit_transition()
	if reaction == HitState.NAME:
		return HitState.NAME

	if swear_animation_finished:
		if not entity.is_on_floor():
			return FallState.NAME
		
		return IdleState.NAME

	return "None"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"swear":
		return
		
	swear_animation_finished = true
