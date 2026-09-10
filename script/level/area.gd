class_name Area
extends Node2D

@export var areaId: int
@export var areaBackgroundFileName: String
@export var scaleY: float

##TODO: refactor
#func _ready():
	##EventManager.change_background.connect(_on_change_background)
