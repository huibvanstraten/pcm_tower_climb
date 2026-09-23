class_name EnemyHitState
extends EnemyState

const NAME := "Hit"
var hit_animation_finished: bool = false
@export var health_component: HealthComponent
@export var hurt: HurtComponent

func enter() -> void:
	super()
	physics_component.halt_horizontal()

	var hit = entity.hit
	health_component.take_hit(hit)
	physics_component.apply_knockback(hit.direction, hit.knockback)
	entity.hit = null

	hit_animation_finished = false
	animation_player.play(&"enemy_hit")

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)

	if hit_animation_finished:
		if health_component.health == 0:
			return EnemyDieState.NAME
		else:
			return PatrolState.NAME

	return "None"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"enemy_hit":
		hit_animation_finished = true
