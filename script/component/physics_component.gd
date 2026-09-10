class_name PhysicsComponent
extends Node

@export var velocityX: float
@export var velocityY: float
@export var gravity: float
@export var acceleration: float = 25.0
@export var airAcceleration: float = 25.0
@export var friction: float = 2000.0
@export var airFriction: float = 3.0
@export var knockbackVelocity: Vector2 = Vector2(20, -10)
@export var knockbackDirection: int 
@export var speed = 300.0
@export var airSpeed = 150.0
@export var direction: Vector2 = Vector2.RIGHT

@export var collisionRotation: float = 0

var facingDirection: int = 1
var defaultGravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	gravity = defaultGravity

func reset_gravity():
	gravity = defaultGravity

func set_velocity(delta: float):
	velocityY += gravity * delta

func reset_velocity():
	velocityY = 0

func set_knockback_direction(knockback_direction: int):
	knockbackDirection = knockback_direction

func knock_back(): 
	velocityX = knockbackVelocity.x * knockbackDirection
	
func move(_delta, inputAxis: float = direction.x):
	velocityX += acceleration * inputAxis
	direction.x = inputAxis
	velocityX = clampf(velocityX, -speed, speed)

func move_in_air(_delta, inputAxis):
	velocityX += airAcceleration * inputAxis
	direction.x = inputAxis
	velocityX = clampf(velocityX, -airSpeed, airSpeed)

func move_to_target(targetPosition: Vector2, delta, attackSpeed: float):
	speed = attackSpeed
	direction = targetPosition
	move(delta)

func stop(delta: float):
	direction.x = 0.0
	velocityX = move_toward(velocityX, 0, friction * delta)

#func air_resistance(delta: float):
	#velocityX = move_toward(velocityX, 0, airFriction * delta)
	
func air_resistance(_delta: float):
	velocityX -= airFriction
	velocityX = clampf(velocityX, 0, airSpeed)
