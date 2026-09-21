class_name HealthComponent
extends Node2D

@export var intial_health = 3
var health: int


func _ready() -> void:
	health = intial_health

func take_hit(hit: Hit) -> void:
	health = max(health - 1, 0)
	print("### Health is now: {0}".format([health]))
