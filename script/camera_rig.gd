class_name CameraRig
extends Node2D


enum TrackingState {
	NORMAL,
	SEPARATED,
	RECOVERING,
}

class CameraAxisResult:
	var position: float
	var state: TrackingState

	func _init(
		new_position: float,
		new_state: TrackingState
	) -> void:
		position = new_position
		state = new_state


const BOUNDARY_THICKNESS := 20.0


@onready var camera: Camera2D = $Camera2D

@onready var left_boundary: StaticBody2D = \
	$PlayerBounds/LeftBoundary

@onready var right_boundary: StaticBody2D = \
	$PlayerBounds/RightBoundary

@onready var left_boundary_shape: CollisionShape2D = \
	$PlayerBounds/LeftBoundary/CollisionShape2D

@onready var right_boundary_shape: CollisionShape2D = \
	$PlayerBounds/RightBoundary/CollisionShape2D

@onready var top_boundary: StaticBody2D = \
	$PlayerBounds/TopBoundary

@onready var top_boundary_shape: CollisionShape2D = \
	$PlayerBounds/TopBoundary/CollisionShape2D
	
@onready var death_zone: Area2D = \
	$DeathZone

@onready var death_zone_shape: CollisionShape2D = \
	$DeathZone/CollisionShape2D


@export_group("Tracking Margins")
@export_range(0.0, 0.5) var left_margin := 0.2
@export_range(0.0, 0.5) var right_margin := 0.2
@export_range(0.0, 0.5) var top_margin := 0.2
@export_range(0.0, 0.5) var bottom_margin := 0.35

@export_group("Tracking Recovery")
@export var recovery_speed := 300.0

@export_group("Player Bounds")
@export var top_boundary_overflow := 100.0

@export_group("Death Zone")
@export var death_zone_distance := 150.0
@export var death_zone_height := 100.0

var players: Array[Player] = []

var horizontal_tracking_state := TrackingState.NORMAL
var vertical_tracking_state := TrackingState.NORMAL


func _ready() -> void:
	EventManager.connect("player_joined", _on_player_joined)
	death_zone.body_entered.connect(_on_death_zone_body_entered)
	
	configure_camera_constraints()


func _physics_process(delta: float) -> void:
	if players.is_empty():
		return

	var movement := get_required_camera_movement(delta)
	global_position += movement


func _on_player_joined(player: Player) -> void:
	register_player(player)


func _on_death_zone_body_entered(body: Node2D) -> void:
	var player := body as Player

	if player == null:
		return

	unregister_player(player)
	EventManager.player_died.emit(player)


func register_player(player: Player) -> void:
	if player in players:
		return

	players.append(player)

	if players.size() == 1:
		global_position = player.global_position

	horizontal_tracking_state = TrackingState.NORMAL
	vertical_tracking_state = TrackingState.NORMAL

	print("CAMERA PLAYER REGISTERED: ", player.name)
	print("CAMERA PLAYERS: ", players.size())


func configure_camera_constraints() -> void:
	var viewport_size := get_viewport_world_size()

	var left_shape := \
		left_boundary_shape.shape as RectangleShape2D

	var right_shape := \
		right_boundary_shape.shape as RectangleShape2D

	var top_shape := \
		top_boundary_shape.shape as RectangleShape2D

	left_shape.size = Vector2(
		BOUNDARY_THICKNESS,
		viewport_size.y
	)

	right_shape.size = Vector2(
		BOUNDARY_THICKNESS,
		viewport_size.y
	)

	top_shape.size = Vector2(
		viewport_size.x,
		BOUNDARY_THICKNESS
	)

	left_boundary.position = Vector2(
		-viewport_size.x * 0.5 - BOUNDARY_THICKNESS * 0.5,
		0.0
	)

	right_boundary.position = Vector2(
		viewport_size.x * 0.5 + BOUNDARY_THICKNESS * 0.5,
		0.0
	)

	top_boundary.position = Vector2(
		0.0,
		-viewport_size.y * 0.5
		- top_boundary_overflow
		- BOUNDARY_THICKNESS * 0.5
	)
	
	var death_shape := \
	death_zone_shape.shape as RectangleShape2D

	death_shape.size = Vector2(
		viewport_size.x,
		death_zone_height
	)

	death_zone.position = Vector2(
		0.0,
		viewport_size.y * 0.5
		+ death_zone_distance
		+ death_zone_height * 0.5
	)


func get_required_camera_movement(delta: float) -> Vector2:
	var viewport_size := get_viewport_world_size()
	var player_bounds := get_player_bounds()

	var left_tracking_offset := \
		viewport_size.x * (0.5 - left_margin)

	var right_tracking_offset := \
		viewport_size.x * (0.5 - right_margin)

	var top_tracking_offset := \
		viewport_size.y * (0.5 - top_margin)

	var bottom_tracking_offset := \
		viewport_size.y * (0.5 - bottom_margin)

	var tracking_min_x := \
		player_bounds.end.x - right_tracking_offset

	var tracking_max_x := \
		player_bounds.position.x + left_tracking_offset

	var tracking_min_y := \
		player_bounds.end.y - bottom_tracking_offset

	var tracking_max_y := \
		player_bounds.position.y + top_tracking_offset

	var half_viewport_width := viewport_size.x * 0.5
	var half_viewport_height := viewport_size.y * 0.5

	var viewport_min_x := \
		player_bounds.end.x - half_viewport_width

	var viewport_max_x := \
		player_bounds.position.x + half_viewport_width

	var viewport_min_y := \
		player_bounds.end.y - half_viewport_height

	var viewport_max_y := \
		player_bounds.position.y + half_viewport_height

	var horizontal_result := get_camera_axis_position(
		global_position.x,
		tracking_min_x,
		tracking_max_x,
		viewport_min_x,
		viewport_max_x,
		horizontal_tracking_state,
		delta
	)

	var vertical_result := get_camera_axis_position(
		global_position.y,
		tracking_min_y,
		tracking_max_y,
		viewport_min_y,
		viewport_max_y,
		vertical_tracking_state,
		delta
	)

	horizontal_tracking_state = horizontal_result.state
	vertical_tracking_state = vertical_result.state

	return Vector2(
		horizontal_result.position - global_position.x,
		vertical_result.position - global_position.y
	)


func get_camera_axis_position(
	current: float,
	tracking_minimum: float,
	tracking_maximum: float,
	viewport_minimum: float,
	viewport_maximum: float,
	state: TrackingState,
	delta: float
) -> CameraAxisResult:
	var tracking_possible := \
		tracking_minimum <= tracking_maximum

	match state:
		TrackingState.NORMAL:
			if not tracking_possible:
				return CameraAxisResult.new(
					clamp_to_viewport(
						current,
						viewport_minimum,
						viewport_maximum
					),
					TrackingState.SEPARATED
				)

			var target = clamp(
				current,
				tracking_minimum,
				tracking_maximum
			)

			return CameraAxisResult.new(
				clamp_to_viewport(
					target,
					viewport_minimum,
					viewport_maximum
				),
				TrackingState.NORMAL
			)

		TrackingState.SEPARATED:
			var target := clamp_to_viewport(
				current,
				viewport_minimum,
				viewport_maximum
			)

			if tracking_possible:
				return CameraAxisResult.new(
					target,
					TrackingState.RECOVERING
				)

			return CameraAxisResult.new(
				target,
				TrackingState.SEPARATED
			)

		TrackingState.RECOVERING:
			if not tracking_possible:
				return CameraAxisResult.new(
					clamp_to_viewport(
						current,
						viewport_minimum,
						viewport_maximum
					),
					TrackingState.SEPARATED
				)

			var target = clamp(
				current,
				tracking_minimum,
				tracking_maximum
			)

			var recovered_position := move_toward(
				current,
				target,
				recovery_speed * delta
			)

			recovered_position = clamp_to_viewport(
				recovered_position,
				viewport_minimum,
				viewport_maximum
			)

			if is_equal_approx(
				recovered_position,
				target
			):
				return CameraAxisResult.new(
					recovered_position,
					TrackingState.NORMAL
				)

			return CameraAxisResult.new(
				recovered_position,
				TrackingState.RECOVERING
			)

	return CameraAxisResult.new(
		current,
		state
	)


func clamp_to_viewport(
	position: float,
	minimum: float,
	maximum: float
) -> float:
	if minimum > maximum:
		return position

	return clamp(
		position,
		minimum,
		maximum
	)


func get_viewport_world_size() -> Vector2:
	var viewport_size := get_viewport_rect().size
	return viewport_size / camera.zoom


func is_world_position_visible(
	world_position: Vector2
) -> bool:
	var viewport_size := get_viewport_world_size()

	var visible_rect := Rect2(
		global_position - viewport_size * 0.5,
		viewport_size
	)

	return visible_rect.has_point(world_position)


func get_tracking_rect() -> Rect2:
	var viewport_size := get_viewport_world_size()

	var left := global_position.x - viewport_size.x * 0.5
	var top := global_position.y - viewport_size.y * 0.5

	var tracking_left := \
		left + viewport_size.x * left_margin

	var tracking_right := \
		left + viewport_size.x * (1.0 - right_margin)

	var tracking_top := \
		top + viewport_size.y * top_margin

	var tracking_bottom := \
		top + viewport_size.y * (1.0 - bottom_margin)

	return Rect2(
		Vector2(
			tracking_left,
			tracking_top
		),
		Vector2(
			tracking_right - tracking_left,
			tracking_bottom - tracking_top
		)
	)


func get_player_bounds() -> Rect2:
	if players.is_empty():
		return Rect2()

	var first_player := players[0]

	var min_x := first_player.global_position.x
	var max_x := first_player.global_position.x
	var min_y := first_player.global_position.y
	var max_y := first_player.global_position.y

	for player in players:
		var position := player.global_position

		min_x = min(min_x, position.x)
		max_x = max(max_x, position.x)
		min_y = min(min_y, position.y)
		max_y = max(max_y, position.y)

	return Rect2(
		Vector2(min_x, min_y),
		Vector2(
			max_x - min_x,
			max_y - min_y
		)
	)


func unregister_player(player: Player) -> void:
	players.erase(player)

	horizontal_tracking_state = TrackingState.NORMAL
	vertical_tracking_state = TrackingState.NORMAL

	print("CAMERA PLAYER UNREGISTERED: ", player.name)
	print("CAMERA PLAYERS: ", players.size())
