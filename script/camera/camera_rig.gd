class_name CameraRig
extends Node2D


const BOUNDARY_THICKNESS := 10.0


@export_group("Tracking")
@export var frame_size := Vector2(400.0, 220.0)

@export_subgroup("Horizontal")
@export var horizontal_tracking_speed := 240.0
@export var horizontal_recovery_speed := 400.0

@export_subgroup("Vertical")
@export var vertical_tracking_speed := 600.0
@export var vertical_recovery_speed := 800.0

@export var edge_deadzone := 2.0

@export_group("Player Bounds")
@export var top_boundary_overflow := 100.0

@export_group("Death Zone")
@export var death_zone_distance := 50.0
@export var death_zone_height := 100.0


@onready var camera: Camera2D = $Camera2D

@onready var left_boundary: StaticBody2D = \
	$PlayerBounds/LeftBoundary

@onready var right_boundary: StaticBody2D = \
	$PlayerBounds/RightBoundary

@onready var top_boundary: StaticBody2D = \
	$PlayerBounds/TopBoundary

@onready var left_boundary_shape: CollisionShape2D = \
	$PlayerBounds/LeftBoundary/CollisionShape2D

@onready var right_boundary_shape: CollisionShape2D = \
	$PlayerBounds/RightBoundary/CollisionShape2D

@onready var top_boundary_shape: CollisionShape2D = \
	$PlayerBounds/TopBoundary/CollisionShape2D

@onready var death_zone: Area2D = $DeathZone

@onready var death_zone_shape: CollisionShape2D = \
	$DeathZone/CollisionShape2D


var players: Array[Player] = []

var area_bounds := Rect2()
var has_area_bounds := false

var was_straddled_x := false
var was_straddled_y := false


func _ready() -> void:
	EventManager.player_joined.connect(
		_on_player_joined
	)

	EventManager.player_respawned.connect(
		_on_player_respawned
	)

	EventManager.player_died.connect(
		_on_player_died
	)
	
	death_zone.body_entered.connect(
		_on_death_zone_body_entered
	)

	_update_screen_boundaries()


func _physics_process(delta: float) -> void:
	_remove_invalid_players()

	if not players.is_empty():
		var movement := _get_tracking_movement(delta)

		global_position += movement

	_clamp_to_area()
	_update_screen_boundaries()


# -------------------------------------------------------------------
# Player registration
# -------------------------------------------------------------------

func register_player(player: Player) -> void:
	if player == null:
		return

	if players.has(player):
		return

	players.append(player)


func unregister_player(player: Player) -> void:
	players.erase(player)


func _on_player_joined(player: Player) -> void:
	register_player(player)


func _on_player_respawned(player: Player) -> void:
	register_player(player)


func _on_player_died(player: Player) -> void:
	unregister_player(player)


func _remove_invalid_players() -> void:
	for index in range(players.size() - 1, -1, -1):
		if not is_instance_valid(players[index]):
			players.remove_at(index)


# -------------------------------------------------------------------
# Area
# -------------------------------------------------------------------

func set_area(area: Area) -> void:
	if area == null:
		has_area_bounds = false
		return

	area_bounds = area.get_camera_bounds()
	has_area_bounds = true

	_clamp_to_area()
	_update_screen_boundaries()


func _clamp_to_area() -> void:
	if not has_area_bounds:
		return

	var viewport_size := get_viewport_world_size()
	var half_viewport := viewport_size * 0.5

	var min_x := area_bounds.position.x + half_viewport.x
	var max_x := area_bounds.end.x - half_viewport.x

	var min_y := area_bounds.position.y + half_viewport.y
	var max_y := area_bounds.end.y - half_viewport.y

	if min_x <= max_x:
		global_position.x = clamp(
			global_position.x,
			min_x,
			max_x
		)
	else:
		global_position.x = area_bounds.get_center().x

	if min_y <= max_y:
		global_position.y = clamp(
			global_position.y,
			min_y,
			max_y
		)
	else:
		global_position.y = area_bounds.get_center().y


func position_at(
	world_position: Vector2
) -> void:
	global_position = world_position

	_clamp_to_area()
	_update_screen_boundaries()
# -------------------------------------------------------------------
# Tracking
# -------------------------------------------------------------------

func _get_tracking_movement(delta: float) -> Vector2:
	var player_bounds := _get_player_bounds()

	var usable_width := (
		frame_size.x
		- edge_deadzone * 2.0
	)

	var usable_height := (
		frame_size.y
		- edge_deadzone * 2.0
	)

	var straddled_x := (
		player_bounds.size.x > usable_width
	)

	var straddled_y := (
		player_bounds.size.y > usable_height
	)

	var movement := Vector2.ZERO

	if not straddled_x:
		movement.x = _get_axis_movement(
			global_position.x,
			player_bounds.position.x,
			player_bounds.end.x,
			frame_size.x * 0.5,
			was_straddled_x,
			horizontal_tracking_speed,
			horizontal_recovery_speed,
			delta
		)

	if not straddled_y:
		movement.y = _get_axis_movement(
			global_position.y,
			player_bounds.position.y,
			player_bounds.end.y,
			frame_size.y * 0.5,
			was_straddled_y,
			vertical_tracking_speed,
			vertical_recovery_speed,
			delta
		)

	was_straddled_x = straddled_x
	was_straddled_y = straddled_y

	return movement

func _get_axis_movement(
	current_position: float,
	player_min: float,
	player_max: float,
	half_frame: float,
	was_straddled: bool,
	tracking_speed: float,
	recovery_speed: float,
	delta: float
) -> float:
	var speed := (
		recovery_speed
		if was_straddled
		else tracking_speed
	)

	var max_movement := speed * delta

	var frame_min := (
		current_position
		- half_frame
		+ edge_deadzone
	)

	var frame_max := (
		current_position
		+ half_frame
		- edge_deadzone
	)

	var overflow_positive := (
		player_max - frame_max
	)

	if overflow_positive > 0.0:
		return min(
			overflow_positive,
			max_movement
		)

	var overflow_negative := (
		frame_min - player_min
	)

	if overflow_negative > 0.0:
		return -min(
			overflow_negative,
			max_movement
		)

	return 0.0


#func _get_axis_movement(
	#current_position: float,
	#player_min: float,
	#player_max: float,
	#half_frame: float,
	#was_straddled: bool,
	#delta: float
#) -> float:
	#var speed := (
		#recovery_speed
		#if was_straddled
		#else tracking_speed
	#)
#
	#var max_movement := speed * delta
#
	#var frame_min := (
		#current_position
		#- half_frame
		#+ edge_deadzone
	#)
#
	#var frame_max := (
		#current_position
		#+ half_frame
		#- edge_deadzone
	#)
#
	#var overflow_positive := (
		#player_max - frame_max
	#)
#
	#if overflow_positive > 0.0:
		#return min(
			#overflow_positive,
			#max_movement
		#)
#
	#if overflow_positive > 0.0:  
		#return overflow_positive
#
	#var overflow_negative := (
		#frame_min - player_min
	#)
#
	#if overflow_negative > 0.0:
		#return -min(
			#overflow_negative,
			#max_movement
		#)
#
	#return 0.0


func _get_player_bounds() -> Rect2:
	var first_player := players[0]

	var min_position := first_player.global_position
	var max_position := first_player.global_position

	for player in players:
		min_position.x = min(
			min_position.x,
			player.global_position.x
		)

		min_position.y = min(
			min_position.y,
			player.global_position.y
		)

		max_position.x = max(
			max_position.x,
			player.global_position.x
		)

		max_position.y = max(
			max_position.y,
			player.global_position.y
		)

	return Rect2(
		min_position,
		max_position - min_position
	)


# -------------------------------------------------------------------
# Screen boundaries
# -------------------------------------------------------------------

func _update_screen_boundaries() -> void:
	var viewport_size := get_viewport_world_size()
	var half_viewport := viewport_size * 0.5

	_update_vertical_boundary(
		left_boundary,
		left_boundary_shape,
		-half_viewport.x
	)

	_update_vertical_boundary(
		right_boundary,
		right_boundary_shape,
		half_viewport.x
	)

	_update_top_boundary(
		half_viewport
	)

	_update_death_zone(
		half_viewport
	)


func _update_vertical_boundary(
	boundary: StaticBody2D,
	collision_shape: CollisionShape2D,
	x_position: float
) -> void:
	boundary.position.x = x_position

	var rectangle := collision_shape.shape as RectangleShape2D

	if rectangle == null:
		return

	var viewport_size := get_viewport_world_size()

	rectangle.size = Vector2(
		BOUNDARY_THICKNESS,
		viewport_size.y
	)


func _update_top_boundary(
	half_viewport: Vector2
) -> void:
	top_boundary.position.y = (
		-half_viewport.y
		- top_boundary_overflow
	)

	var rectangle := (
		top_boundary_shape.shape
		as RectangleShape2D
	)

	if rectangle == null:
		return

	var viewport_size := get_viewport_world_size()

	rectangle.size = Vector2(
		viewport_size.x,
		BOUNDARY_THICKNESS
	)


func _update_death_zone(
	half_viewport: Vector2
) -> void:
	death_zone.position.y = (
		half_viewport.y
		+ death_zone_distance
		+ death_zone_height * 0.5
	)

	var rectangle := (
		death_zone_shape.shape
		as RectangleShape2D
	)

	if rectangle == null:
		return

	var viewport_size := get_viewport_world_size()

	rectangle.size = Vector2(
		viewport_size.x,
		death_zone_height
	)


func _on_death_zone_body_entered(
	body: Node2D
) -> void:
	var player := body as Player

	if player == null:
		return

	EventManager.player_died.emit(player)

# -------------------------------------------------------------------
# Viewport
# -------------------------------------------------------------------

func get_viewport_world_size() -> Vector2:
	return (
		get_viewport_rect().size
		/ camera.zoom
	)


func get_viewport_world_rect() -> Rect2:
	var viewport_size := get_viewport_world_size()

	var rect := Rect2(
		global_position - viewport_size * 0.5,
		viewport_size
	)

	print("CAMERA VIEW RECT: ", rect)

	return rect


func is_world_position_visible(
	world_position: Vector2
) -> bool:
	return get_viewport_world_rect().has_point(
		world_position
	)
