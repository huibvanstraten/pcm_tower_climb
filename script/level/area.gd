class_name Area
extends Node2D

#TODO: improve by removing path hardcoding
@onready var background: ParallaxBackground = $"../../Ruined_City"
@export var areaBackgroundFileName: String

@export var areaId: int
@export var area_music: AudioStream

var left_boundary: Area2D:
	get:
		return $AreaBoundaries/Left

var right_boundary: Area2D:
	get:
		return $AreaBoundaries/Right

var top_boundary: Area2D:
	get:
		return $AreaBoundaries/Top

var bottom_boundary: Area2D:
	get:
		return $AreaBoundaries/Bottom

@export var scaleY: float


func activate() -> void:
	MusicManager.play(area_music)


func deactivate() -> void:
	pass

func _on_change_background(transitionAreaId: int):
	if transitionAreaId == areaId:
		var newTexture = load(areaBackgroundFileName)
		var currentBackground = background.get_child(4) as ParallaxLayer
		currentBackground.motion_offset.y = scaleY
		var sprite = currentBackground.get_child(0) as Sprite2D
		sprite.texture = newTexture
	
	
func get_camera_bounds() -> Rect2:
	var left := _get_boundary_shape_position(
		left_boundary
	).x

	var right := _get_boundary_shape_position(
		right_boundary
	).x

	var top := _get_boundary_shape_position(
		top_boundary
	).y

	var bottom := _get_boundary_shape_position(
		bottom_boundary
	).y

	return Rect2(
		Vector2(
			left,
			top
		),
		Vector2(
			right - left,
			bottom - top
		)
	)


func _get_boundary_shape_position(
	boundary: Area2D
) -> Vector2:
	var collision_shape := (
		boundary.get_node("CollisionShape2D")
		as CollisionShape2D
	)

	return collision_shape.global_position
