class_name CharacterData
extends Resource

@export_group("Identity")
@export var id: StringName
@export var display_name: String
@export_multiline var description: String

@export_group("Visuals")
@export var portrait: Texture2D
@export var animations: AnimationLibrary

@export_group("Ground Movement")
@export var speed: float = 100.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0

@export_group("Air Movement")
@export var air_speed: float = 150.0
@export var air_acceleration: float = 1000.0
@export var air_friction: float = 300.0

@export_group("Jump")
@export var jump_velocity: float = -400.0
@export_range(0.0, 1.0) var jump_cut_multiplier: float = 0.4
