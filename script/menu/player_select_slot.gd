class_name PlayerSelectSlot
extends PanelContainer


enum State {
	EMPTY,
	SELECTING,
	CONFIRMED,
}

@export var player_slot: int

@onready var player_label: Label = %PlayerLabel
@onready var character_label: Label = %CharacterLabel
@onready var status_label: Label = %StatusLabel
@onready var portrait_container: CenterContainer = %PortraitContainer
@onready var portrait: TextureRect = %Portrait
@onready var stats_label: Label = %StatsLabel
@onready var previous_label: Label = %PreviousLabel
@onready var next_label: Label = %NextLabel

var character_roster: CharacterRoster

var state: PlayerSelectSlot.State = State.EMPTY
var session: PlayerInputSession = null

var empty_style := StyleBoxFlat.new()
var selecting_style := StyleBoxFlat.new()
var confirmed_style := StyleBoxFlat.new()

func _ready() -> void:
	_setup_styles()
	player_label.text = "PLAYER %d" % player_slot
	_update_ui()



func _update_character() -> void:
	if session == null or character_roster == null:
		portrait.texture = null
		character_label.text = ""
		stats_label.text = ""
		return

	var character := character_roster.get_character(
		session.selection.character_index
	)

	if character == null:
		portrait.texture = null
		character_label.text = ""
		stats_label.text = ""
		return

	portrait.texture = character.portrait
	character_label.text = character.display_name

	stats_label.text = (
		"SPEED: %.0f\nJUMP: %.0f"
		% [
			character.speed,
			absf(character.jump_velocity)
		]
	)
	
	
func assign_session(
	player_input_session: PlayerInputSession
) -> void:
	session = player_input_session

	if session.selection.confirmed:
		state = State.CONFIRMED
	else:
		state = State.SELECTING

	_update_ui()


func clear_session() -> void:
	session = null
	state = State.EMPTY
	_update_ui()


func confirm() -> void:
	if state != State.SELECTING:
		return

	state = State.CONFIRMED
	_update_ui()



func _update_ui() -> void:
	match state:
		State.EMPTY:
			add_theme_stylebox_override("panel", empty_style)

			portrait_container.hide()
			previous_label.self_modulate.a = 0.0
			next_label.self_modulate.a = 0.0
			character_label.hide()
			stats_label.hide()

			status_label.text = "PRESS START\nTO JOIN"
			_update_character()

		State.SELECTING:
			add_theme_stylebox_override("panel", selecting_style)

			portrait_container.show()
			previous_label.self_modulate.a = 1.0
			next_label.self_modulate.a = 1.0
			character_label.show()
			stats_label.show()

			_update_character()
			status_label.text = "SELECTING"

		State.CONFIRMED:
			add_theme_stylebox_override("panel", confirmed_style)

			portrait_container.show()
			previous_label.self_modulate.a = 0.0
			next_label.self_modulate.a = 0.0
			character_label.show()
			stats_label.show()

			_update_character()
			status_label.text = "READY"


func _get_character_name() -> String:
	if session == null:
		return ""

	return "CHARACTER %s" % (
		session.selection.character_index + 1
	)


func _setup_styles() -> void:
	empty_style.bg_color = Color("#202228")
	empty_style.border_color = Color("#454851")

	selecting_style.bg_color = Color("#252932")
	selecting_style.border_color = Color("#8be9fd")

	confirmed_style.bg_color = Color("#253029")
	confirmed_style.border_color = Color("#7ee787")

	for style in [
		empty_style,
		selecting_style,
		confirmed_style,
	]:
		style.set_border_width_all(2)
		style.set_corner_radius_all(3)
