class_name HitState
extends PlayerState

const NAME := "Hit"
@export var hurt_component: HurtComponent
@export var health_component: HealthComponent
@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
var hit_animation_finished: bool = false


func enter() -> void:
	super()

	var hit = player.hit
	health_component.take_hit(hit)
	physics_component.apply_knockback(hit.direction, hit.knockback)
	player.hit = null

	hit_animation_finished = false
	animation_player.play(&"hit")


func exit() -> void:
	super()


func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)

	if hit_animation_finished:
		if health_component.health == 0:
			return DieState.NAME
		else: 
			return IdleState.NAME
	else:
		return "None"


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"hit":
		return
	hit_animation_finished = true
