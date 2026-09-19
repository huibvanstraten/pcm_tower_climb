class_name PlayerHUDInfo
extends MarginContainer


@onready var player_name: Label = %PlayerName
@onready var health_value: Label = %HealthValue
@onready var ability_value: Label = %AbilityValue


func setup(player_id: int) -> void:
	player_name.text = "P%s" % player_id
	health_value.text = "100"
	ability_value.text = "75%"
