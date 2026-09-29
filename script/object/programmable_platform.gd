class_name ProgrammablePlatform
extends Node2D


@onready var programmable_component: ProgrammableComponent = \
	$Terminal

@onready var platform: StaticBody2D = \
	$Platform

@onready var platform_sprite: Sprite2D = \
	$Platform/Sprite2D

@onready var platform_collision: CollisionShape2D = \
	$Platform/CollisionShape2D

@onready var animation_player: AnimationPlayer = \
	$Platform/AnimationPlayer

var active := false


func _ready() -> void:
	programmable_component.programming_completed.connect(
		_on_programming_completed
	)

	_set_platform_active(false)


func _on_programming_completed(player: Player) -> void:
	activate()

	EventManager.programming_finished.emit(player)


func activate() -> void:
	if active:
		return

	active = true
	_set_platform_active(true)


func _set_platform_active(value: bool) -> void:
	platform_sprite.visible = value

	platform_collision.set_deferred(
		"disabled",
		not value
	)
