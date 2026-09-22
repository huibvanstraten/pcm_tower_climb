class_name HitState
extends PlayerState

const NAME := "Hit"

var hit_animation_finished: bool = false

func enter() -> void:
	super()

	var hit = entity.hit
	entity.health_component.take_hit(hit)
	entity.physics_component.apply_knockback(hit.direction, hit.knockback)
	entity.hit = null

	hit_animation_finished = false
	animation_player.play(&"hit")

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	entity.physics_component.apply_gravity(delta)

	if hit_animation_finished:
		if entity.health_component.health == 0:
			return DieState.NAME
		else: 
			return IdleState.NAME
	
	return "None"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"hit":
		return
		
	hit_animation_finished = true
