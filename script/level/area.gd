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
	
	
