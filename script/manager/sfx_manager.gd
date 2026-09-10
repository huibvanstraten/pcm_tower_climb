extends Node

var numPlayers = 8

var availablePlayers = []  # The available players.
var queue = []  # The queue of sounds to play.

func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for amount in numPlayers:
		var player = AudioStreamPlayer.new()
		add_child(player)
		availablePlayers.append(player)
		player.finished.connect(_on_stream_finished.bind(player))

func _process(_delta):
	# Play a queued sound if any players are available.
	if not queue.is_empty() and not availablePlayers.is_empty():
		availablePlayers[0].stream = load(queue.pop_front())
		availablePlayers[0].play()
		availablePlayers.pop_front()
	
func play(soundPath):
	queue.append(soundPath)
	
func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	availablePlayers.append(stream)
