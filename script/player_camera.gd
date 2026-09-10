class_name PlayerCamera
extends Camera2D

func _ready():
	set_camera_boundaries()
	EventManager.transition_to_area.connect(set_camera_boundaries)

func set_camera_boundaries(_areaId: int = 0):
	var levelBoundaries: Array = LevelManager.get_level_boundaries()

	limit_left = (levelBoundaries[0] as StaticBody2D).global_position.x as int
	limit_right = (levelBoundaries[1] as StaticBody2D).global_position.x as int
	limit_top = (levelBoundaries[2] as StaticBody2D).global_position.y as int
	limit_bottom = (levelBoundaries[3] as StaticBody2D).global_position.y as int
