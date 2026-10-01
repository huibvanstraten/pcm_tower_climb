class_name ProgrammablePlatform
extends Node2D


@export var activation_channel: StringName

@onready var platform_sprite: AnimatedSprite2D = \
	$AnimatedSprite2D

@onready var platform_collision: CollisionShape2D = \
	$Platform/CollisionShape2D


var active := false


func _ready() -> void:
	EventManager.programmable_activated.connect(
		_on_programmable_activated
	)

	platform_sprite.animation_finished.connect(
		_on_platform_animation_finished
	)

	platform_collision.disabled = true
	platform_sprite.play("preview")


func _on_programmable_activated(
	channel: StringName
) -> void:
	if channel != activation_channel:
		return

	activate()


func activate() -> void:
	if active:
		return

	active = true
	platform_sprite.play("appear")


func _on_platform_animation_finished() -> void:
	if platform_sprite.animation != &"appear":
		return

	platform_sprite.play("block")

	platform_collision.set_deferred(
		"disabled",
		false
	)
