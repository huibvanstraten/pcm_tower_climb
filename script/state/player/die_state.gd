class_name DieState
extends PlayerState

const NAME := "Die"

var die_animation_finished: bool = false


func enter() -> void:
	super()
	physics_component.reset_velocity()

func exit() -> void:
	super()

func physics_update(delta: float) -> String:	
	if die_animation_finished:
		EventManager.player_died.emit(entity)
		die_animation_finished = false

	return "None"


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"die":
		return
	
	die_animation_finished = true
