class_name Player
extends Entity

@onready var input_source: PlayerInputSource = $Input

var player_id: int

var command: PlayerCommand

var playerFreeze: bool = false

func _ready():
	EventManager.connect("freeze_player", freeze)


func _physics_process(delta: float) -> void:
	command = input_source.get_command()

	stateMachine.physics_update(delta, command)

	if not is_on_floor():
		physicsComponent.set_velocity(delta)

	if not playerFreeze:
		move_and_slide_with_coyote_jump()
	

func move_and_slide_with_coyote_jump():
	velocity.x = physicsComponent.velocityX
	velocity.y = physicsComponent.velocityY
	move_and_slide()

func freeze(shouldFreeze: bool):
	playerFreeze = shouldFreeze
