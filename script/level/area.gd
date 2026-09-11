class_name Area
extends Node2D

@onready var background: ParallaxBackground = $"../../BackgroundCity"

@export var areaId: int

@onready var left_boundary: StaticBody2D = $AreaBoundaries/Left
@onready var right_boundary: StaticBody2D = $AreaBoundaries/Right
@onready var top_boundary: StaticBody2D = $AreaBoundaries/Top
@onready var bottom_boundary: StaticBody2D = $AreaBoundaries/Bottom

@export var areaBackgroundFileName: String
@export var scaleY: float

#TODO: refactor
func _ready():
	EventManager.change_background.connect(_on_change_background)

func _on_change_background(transitionAreaId: int):
	if transitionAreaId == areaId:
		var newTexture = load(areaBackgroundFileName)
		var currentBackground = background.get_child(4) as ParallaxLayer
		currentBackground.motion_offset.y = scaleY
		var sprite = currentBackground.get_child(0) as Sprite2D
		sprite.texture = newTexture
	
	
