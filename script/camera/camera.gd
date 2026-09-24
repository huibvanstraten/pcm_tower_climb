class_name Camera
extends Camera2D

func _ready():
	set_camera_boundaries(1)
	#EventManager.transition_to_area.connect(set_camera_boundaries)

func set_camera_boundaries(_areaId: int):
	var current_area: Area = LevelManager.get_current_area()

	limit_left = (current_area.left_boundary as Area2D).global_position.x as int
	limit_right = (current_area.right_boundary as Area2D).global_position.x as int 
	limit_top = (current_area.top_boundary as Area2D).global_position.y as int
	limit_bottom = (current_area.bottom_boundary as Area2D).global_position.y as int
