extends Node

@export var pool_size: int = 16

var available_players: Array[AudioStreamPlayer] = []


func _ready() -> void:
	for i in pool_size:
		var player := AudioStreamPlayer.new()
		add_child(player)

		player.finished.connect(
			_on_stream_finished.bind(player)
		)

		available_players.append(player)


func play(stream: AudioStream) -> void:
	if stream == null:
		return

	if available_players.is_empty():
		return

	var player = available_players.pop_front()

	player.stream = stream
	player.play()


func _on_stream_finished(player: AudioStreamPlayer) -> void:
	player.stream = null
	available_players.append(player)
