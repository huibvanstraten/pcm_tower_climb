class_name HitState
extends State

@export var physics_component: PhysicsComponent
var hit_data: Hit
var hit_animation_finished: bool

func enter() -> void:
	super()

	hit_animation_finished = false

	if hit_data == null:
		return

	physics_component.apply_knockback(
		hit_data.direction,
		hit_data.knockback
	)

	animation_player.play(&"hit")

func exit() -> void:
	super()

func handle_command(command: PlayerCommand) -> void:
	pass

func update(delta: float) -> void:
	if hit_animation_finished:
		state_machine.change_state("Fall")

func physics_update(delta: float) -> void:
	physics_component.apply_gravity(delta)

	if entity.is_on_floor():
		state_machine.change_state("Idle")

func set_hit(hit: Hit) -> void:
	hit_data = hit
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"hit":
		return
	hit_animation_finished = true
	print("Hit animation finished...")
