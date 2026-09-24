class_name PlayerStateMachine
extends StateMachine

@export var jump_component: JumpComponent

func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	super(delta)
	jump_component._update_jump_buffer(delta, entity.command)
	jump_component._update_coyote_time(delta)

func change_state(to_state: String) -> void:
	super(to_state)
