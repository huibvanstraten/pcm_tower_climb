class_name ProgrammableComponent
extends Node

signal programming_completed(player: Player)

var players_in_range: Array[Player] = []
var programming_player: Player = null

@onready var programming_area: Area2D = $ProgrammingArea
@onready var programming_timer: Timer = $ProgrammingTimer


func _ready() -> void:
	EventManager.programming_started.connect(
		_on_programming_started
	)
	EventManager.programming_cancelled.connect(
		_on_programming_cancelled
	)

	programming_timer.timeout.connect(
		_on_programming_completed
	)

	programming_area.body_entered.connect(
		_on_body_entered
	)
	programming_area.body_exited.connect(
		_on_body_exited
	)


func _on_programming_started(player: Player) -> void:
	if player not in players_in_range:
		return

	if programming_player != null:
		return

	programming_player = player
	programming_timer.start()


func _on_programming_cancelled(player: Player) -> void:
	if player != programming_player:
		return

	programming_timer.stop()
	programming_player = null


func _on_programming_completed() -> void:
	if programming_player == null:
		return

	var player := programming_player
	programming_player = null

	programming_completed.emit(player)


func _on_body_entered(body: Node2D) -> void:
	var player := body as Player

	if player == null:
		return

	if player not in players_in_range:
		players_in_range.append(player)


func _on_body_exited(body: Node2D) -> void:
	var player := body as Player

	if player == null:
		return

	players_in_range.erase(player)

	if player != programming_player:
		return

	programming_timer.stop()
	programming_player = null

	EventManager.programming_finished.emit(player)
