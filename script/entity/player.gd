class_name Player
extends Entity

var player_id: int
var playerFreeze: bool = false

func _ready():
	EventManager.connect("freeze_player", freeze)
	print("PLAYER READY")
	print("player global position: ", global_position)
	print("camera global position: ", $Camera2D.global_position)
	print("camera enabled: ", $Camera2D.enabled)
	print("physics component: ", physicsComponent)

func _physics_process(delta):
	#var inputAxis = Input.get_axis("move_left", "move_right")
	#var currentState = stateMachine.currentState
	bodyCollisionShape.rotation_degrees = physicsComponent.collisionRotation
	
	
	if not is_on_floor():
		physicsComponent.set_velocity(delta)
		
		#if inputAxis != 0 and stateMachine.can_move():
			#physicsComponent.move_in_air(delta, sign(inputAxis))
			#flipComponent.flip()
			#pass
		#elif inputAxis == 0 and currentState != HitState:
			#physicsComponent.air_resistance(delta)
	#else:
		#if inputAxis != 0 and stateMachine.can_move():
			#physicsComponent.move(delta, sign(inputAxis))
			#flipComponent.flip()
		#elif inputAxis == 0 and currentState != HitState:
			#physicsComponent.stop(delta)
	
	if not playerFreeze:
		move_and_slide_with_coyote_jump()

func move_and_slide_with_coyote_jump():
	velocity.x = physicsComponent.velocityX
	velocity.y = physicsComponent.velocityY
	move_and_slide()

func freeze(shouldFreeze: bool):
	playerFreeze = shouldFreeze
