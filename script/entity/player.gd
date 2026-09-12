class_name Player
extends Entity

@onready var jump_component: JumpComponent = $Components/Jump
@onready var physics_component: PhysicsComponent = $Components/Physics
@onready var flip_component: FlipComponent = $Components/Flip
@onready var state_machine: PlayerStateMachine = $StateMachine

var player_id: int
var is_frozen: bool = false


func _ready() -> void:
	EventManager.connect("freeze_player", freeze)

func handle_command(
	delta: float,
	command: PlayerCommand
) -> void:

	state_machine.physics_update(delta, command)

func _physics_process(delta: float) -> void:
	if is_frozen:
		return

	move_and_slide()


func freeze(should_freeze: bool) -> void:
	is_frozen = should_freeze
