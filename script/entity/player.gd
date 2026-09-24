class_name Player
extends Entity

var player_id: int
var command: PlayerCommand = PlayerCommand.new()
var hit: Hit = null


var character_data: CharacterData

@onready var move_component: MoveComponent = $Components/Move
@onready var jump_component: JumpComponent = $Components/Jump


func configure(character: CharacterData) -> void:
	assert(character != null)

	character_data = character

	move_component.speed = character.speed
	move_component.acceleration = character.acceleration
	move_component.friction = character.friction

	move_component.air_speed = character.air_speed
	move_component.air_acceleration = character.air_acceleration
	move_component.air_friction = character.air_friction

	jump_component.jump_velocity = character.jump_velocity
	jump_component.jump_cut_multiplier = (
		character.jump_cut_multiplier
	)

	if character.sprite_frames != null:
		animationComponent.sprite_frames = character.sprite_frames


func handle_command(command: PlayerCommand) -> void:
	if command:
		self.command = command

func is_hit() -> bool:
	if hit:
		return true
	else: 
		return false
