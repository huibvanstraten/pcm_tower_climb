class_name PlayerHUDSlot
extends PanelContainer


enum State {
	EMPTY,
	READY,
	PLAYING,
	WAITING,
}


@export var player_hud_info_scene: PackedScene

@onready var ready_label: RichTextLabel = %ReadyLabel
@onready var waiting_label: RichTextLabel = %WaitingLabel
@onready var playing_container: Control = %PlayingContainer

var player_hud_info: Control = null


func _ready() -> void:
	set_state(State.EMPTY)


func set_state(
	state: PlayerHUDSlot.State,
	player_id: int = -1
) -> void:
	ready_label.visible = false
	waiting_label.visible = false
	playing_container.visible = false

	match state:
		State.EMPTY:
			pass

		State.READY:
			ready_label.visible = true


		State.PLAYING:
			playing_container.visible = true
			ensure_player_hud_info(player_id)

		State.WAITING:
			waiting_label.visible = true


func ensure_player_hud_info(player_id: int) -> void:
	if player_hud_info == null:
		player_hud_info = player_hud_info_scene.instantiate()
		playing_container.add_child(player_hud_info)

	player_hud_info.setup(player_id)
