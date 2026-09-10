class_name FlipComponent
extends Node2D

@export var bodyCollisionShape: CollisionShape2D = null
@export var flipMarker: Marker2D = null
@export var stateMachine: StateMachine = null

@export var animationComponent: AnimatedSprite2D = null
@export var physicsComponent: PhysicsComponent = null

func flip():
	bodyCollisionShape = stateMachine.currentState.collisionshape
	var facingDirection = sign(physicsComponent.direction.x)
	var facingRight = facingDirection > 0
	physicsComponent.facingDirection = facingDirection
	
	if !facingRight:
		bodyCollisionShape.rotation_degrees = physicsComponent.collisionRotation * -1
		animationComponent.set_flip_h(facingRight)
		flipMarker.scale.x = -1
	else:
		bodyCollisionShape.rotation_degrees = physicsComponent.collisionRotation
		flipMarker.scale.x = 1
		animationComponent.set_flip_h(!facingRight)

func knockbackFlip():
	pass
