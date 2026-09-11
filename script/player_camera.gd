class_name PlayerCamera
extends Camera2D

func _ready():
	print("CAMERA READY")
	print("camera pos before limits: ", global_position)
	set_camera_boundaries()
	print("camera limits:")
	print("left: ", limit_left)
	print("right: ", limit_right)
	print("top: ", limit_top)
	print("bottom: ", limit_bottom)
	EventManager.transition_to_area.connect(set_camera_boundaries)

func set_camera_boundaries(_areaId: int = 0):
	var area: Area = LevelManager.get_current_area()

	limit_left = int(area.left_boundary.global_position.x)
	limit_right = int(area.right_boundary.global_position.x)
	limit_top = int(area.top_boundary.global_position.y)
	limit_bottom = int(area.bottom_boundary.global_position.y)
