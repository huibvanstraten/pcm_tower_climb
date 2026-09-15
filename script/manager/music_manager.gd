extends Node

var player: AudioStreamPlayer


func _ready() -> void:
	player = AudioStreamPlayer.new()
	add_child(player)


func play(stream: AudioStream) -> void:
	if stream == null:
		stop()
		return

	if player.stream == stream and player.playing:
		return

	player.stream = stream
	player.play()


func stop() -> void:
	player.stop()
	player.stream = null
