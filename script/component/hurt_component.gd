class_name HurtComponent
extends Area2D

@export var player: CharacterBody2D
@export var health_component: HealthComponent

var accepts_friendly_fire := true
var accepts_enemy_hits := true


func receive_hit(hit: Hit) -> void:
	if hit.source is Player and player is Player:
		hit.kind = Hit.Kind.FRIENDLY_FIRE

	# Ignore hits while hit
	if hit.kind == Hit.Kind.FRIENDLY_FIRE:
		if not accepts_friendly_fire:
			return
	elif not accepts_enemy_hits:
		return

	# enemy-hit priority.
	if player.hit != null:
		if player.hit.kind == Hit.Kind.NORMAL:
			return

		if hit.kind == Hit.Kind.FRIENDLY_FIRE:
			return

	player.hit = hit
