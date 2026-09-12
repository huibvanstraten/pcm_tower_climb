class_name Player
extends Entity

@onready var input_source: PlayerInputSource = $Input
@onready var jump_component: JumpComponent = $Components/Jump
@onready var physics_component: PhysicsComponent = $Components/Physics
@onready var flip_component: FlipComponent = $Components/Flip
@onready var state_machine: PlayerStateMachine = $StateMachine

var player_id: int
var is_frozen: bool = false


func _ready() -> void:
	EventManager.connect("freeze_player", freeze)


func _physics_process(delta: float) -> void:
	if is_frozen:
		return

	var command := input_source.get_command()

	jump_component.physics_update(delta, command)
	physics_component.apply_gravity(delta)
	state_machine.physics_update(delta, command)

	move_and_slide()


func freeze(should_freeze: bool) -> void:
	is_frozen = should_freeze
