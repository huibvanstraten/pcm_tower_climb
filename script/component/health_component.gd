class_name HealthComponent
extends Node2D

@export var entity: CharacterBody2D
@export var intial_health: int
var health: int


func _ready() -> void:
	health = intial_health

func take_hit(hit: Hit) -> void:
	health = max(health - 1, 0)
	print("{0}'s health is now: {1}".format([entity.name, health]))
