class_name PlayerHUDInfo
extends MarginContainer


@onready var player_name: Label = %PlayerName
@onready var health_value: Label = %HealthValue
@onready var fragment_label: Label = %FragmentLabel


func setup(player_id: int) -> void:
	player_name.text = "P%s" % player_id
	health_value.text = "100"


func set_fragments(amount: int) -> void:
	fragment_label.text = str(amount)
