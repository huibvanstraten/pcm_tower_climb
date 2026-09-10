extends AudioStreamPlayer

var musicFolderPath: String = "res://assets/audio/music"
var songs: Array
var nextSong: String = "res://assets/audio/music/Bzzt bzzt mf 3.wav"

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func play_song(path: String):
	stream = load(path)
	if stream:
		play()
		EventManager.emit_signal("play_next_song", path)
	else:
		print("Failed to load audio stream from path: " + path)

func play_song_from_list():
	play_song(nextSong)

	var index: int = songs.find(nextSong)
	if index + 1 == songs.size():
		nextSong = songs[0]
	else: 
		nextSong = songs[index + 1] 

func _get_all_songs():
	var dir = DirAccess.open(musicFolderPath)
	
	if dir:
		dir.list_dir_begin()
		
		var file_name = dir.get_next()
		while file_name != "":
			# Skip directories
			if !dir.current_is_dir() and !file_name.ends_with(".import"):
				songs.append(musicFolderPath + "/" + file_name)
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		push_error("Failed to open directory: ", musicFolderPath)
