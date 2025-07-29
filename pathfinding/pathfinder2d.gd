@icon("res://editor/icons/navigation-arrow-fill.svg")
class_name Pathfinder2D
extends Node


signal map_changed()


@export_range(0.1, 1000.0, 0.01, "or_greater", "suffix:px") var target_desired_distance : float = 10.0

@export_group("Pathfinding")
@export var heuristic : AStarGrid2D.Heuristic
@export var diagonal_mode : AStarGrid2D.DiagonalMode
@export var simplify_path : bool = false
@export var allow_partial_path : bool = true

@export_group("Debug")
@export var debug_enabled : bool = false
@export var path_line_color := Color.RED
@export var path_line_width : float = 1.0


var pathfinding_map : PathfindingMap :
	get:
		return pathfinding_map
	set(value):
		pathfinding_map = value
		__init_astar_grid()
		__init_astar_options()
		__update_grid_layout()
		map_changed.emit()
		return
var target_position : Vector2 :
	get:
		return target_position
	set(value):
		target_position = value
		if pathfinding_map:
			__find_path()
		return


var __astar_grid : AStarGrid2D
var __path_coords : Array[Vector2i]

var __debugger : PathfindingDebugger


@onready var parent2d : Node2D = get_parent()


func _ready() -> void:
	if debug_enabled:
		__debugger = PathfindingDebugger.new(path_line_color, path_line_width)
		add_child(__debugger)
	return


#region Initialization functions

func __init_astar_grid() -> void:
	__astar_grid = AStarGrid2D.new()
	__astar_grid.region = pathfinding_map.region
	__astar_grid.cell_size = pathfinding_map.cell_size
	__astar_grid.update()
	return


func __init_astar_options() -> void:
	__astar_grid.default_compute_heuristic = heuristic
	__astar_grid.default_estimate_heuristic = heuristic
	__astar_grid.diagonal_mode = diagonal_mode
	__astar_grid.jumping_enabled = simplify_path
	return

#endregion


func get_path_coords() -> Array[Vector2i]:
	return __path_coords


func get_path_positions() -> Array[Vector2]:
	var path_positions : Array[Vector2]
	for coords : Vector2i in __path_coords:
		path_positions.append(pathfinding_map.layer.map_to_local(coords))
	return path_positions


func get_next_path_position() -> Vector2:
	var next_position : Vector2
	if __path_coords.size() > 1:
		# Index 1 is used because index 0 contains the coordinates of the parent node itself.
		next_position = pathfinding_map.layer.map_to_local(__path_coords[1])
	return next_position


func is_target_reached() -> bool:
	return parent2d.position.distance_to(target_position) <= target_desired_distance


func __update_grid_layout() -> void:
	for cell : Vector2i in pathfinding_map.solid_cells:
		__astar_grid.set_point_solid(cell, true)
	return


func __is_valid_destination_coords(from: Vector2i, to: Vector2i) -> bool:
	var result : bool = false
	if from != to:
		if __astar_grid.is_in_boundsv(from) and __astar_grid.is_in_boundsv(to):
			result = true
	return result


func __find_path() -> void:
	if not is_target_reached():
		var start_coords : Vector2i = pathfinding_map.layer.local_to_map(parent2d.position)
		var end_coords : Vector2i = pathfinding_map.layer.local_to_map(target_position)
		if __is_valid_destination_coords(start_coords, end_coords):
			__path_coords = __astar_grid.get_id_path(start_coords, end_coords, allow_partial_path)
	if debug_enabled:
		__debug()
	return


func __debug() -> void:
	__debugger.points = PackedVector2Array(get_path_positions())
	__debugger.queue_redraw()
	return
