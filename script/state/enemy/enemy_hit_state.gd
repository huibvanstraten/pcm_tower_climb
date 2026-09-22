class_name EnemyHitState
extends EnemyState

const NAME := "Hit"
@export var physics_component: PhysicsComponent
@export var move_component: MoveComponent
@export var flip_component: FlipComponent
var hit_animation_finished: bool = false

func enter() -> void:
	super()

	var hit = entity.hit
	entity.hit = null

	hit_animation_finished = false
	animation_player.play(&"hit")

func exit() -> void:
	super()

func physics_update(delta: float) -> String:
	physics_component.apply_gravity(delta)

	if hit_animation_finished:
		return DieState.NAME

	return "None"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"hit":
		return
	hit_animation_finished = true
