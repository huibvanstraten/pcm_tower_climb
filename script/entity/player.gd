class_name Player
extends Entity

#@onready var jump_component: JumpComponent = $Components/Jump
#@onready var move_component: MoveComponent = $Components/Move
#@onready var physics_component: PhysicsComponent = $Components/Physics
#@onready var flip_component: FlipComponent = $Components/Flip
@onready var state_machine: StateMachine = $StateMachine
#@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player_id: int
var is_hit = false
#var is_frozen: bool = false

func _ready() -> void:
	#EventManager.connect("freeze_player", freeze)
	#state_machine.start()
	pass

func handle_command(command: PlayerCommand) -> void:
	#jump_component.physics_update(delta, command)
	if command:
		state_machine.handle_command(command)

#func _physics_process(delta: float) -> void:
	#if is_frozen:
		#return
	#move_and_slide()

#func freeze(should_freeze: bool) -> void:
	#is_frozen = should_freeze

#func hit(hit_data: Hit) -> void:
## TODO: this should be managed via a property on the player???
	#is_hit = true
