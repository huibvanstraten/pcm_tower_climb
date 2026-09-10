extends Node2D

var player: CharacterBody2D = null
var last_spawn_point = null
var player_node_path: NodePath

func set_spawn_point(spawn_point_name):
	last_spawn_point = spawn_point_name
	
func spawn_player(spawn_position) -> Player:
	if player == null:
		player = preload("res://scene/player.tscn").instantiate()
		var level = LevelManager.get_current_level()
		EventManager.spawn_player.emit(player)
		level.add_child(player)
		
	else:
		#var health = player.find_child("Health") as HealthComponent
		#health.set_health()
		#var physics = player.find_child("Physics") as PhysicsComponent
		#physics.reset_velocity()
		#var camera = player.find_child("Camera2D") as Camera2D
		#camera.set_camera_boundaries()
		
		EventManager.change_background.emit(1)
	
	if last_spawn_point == null:
		player.position = spawn_position
	else:
		player.position = last_spawn_point

	return player
