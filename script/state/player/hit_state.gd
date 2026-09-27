class_name HitState
extends PlayerState

const NAME := "Hit"
@export var hurt_component: HurtComponent
@export var health_component: HealthComponent

var hit_animation_finished: bool = false

func enter() -> void:
	hurt_component.accepts_friendly_fire = false
	hurt_component.accepts_enemy_hits = false

	var hit = entity.hit
	health_component.take_hit(hit)
	physics_component.apply_knockback(hit.direction, hit.knockback)

	entity.hit = null

	hit_animation_finished = false

	super()


func exit() -> void:
	hurt_component.accepts_friendly_fire = true
	hurt_component.accepts_enemy_hits = true
	super()
	

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)

	if hit_animation_finished:
		if health_component.health == 0:
			return DieState.NAME

		else: 
			return IdleState.NAME

	return "None"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"hit":
		return
		
	hit_animation_finished = true
