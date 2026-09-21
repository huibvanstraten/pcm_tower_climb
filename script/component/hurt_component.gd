class_name HurtComponent
extends Area2D

@export var player: CharacterBody2D
@export var health_component: HealthComponent


func receive_hit(hit: Hit) -> void:
	player.hit = hit
