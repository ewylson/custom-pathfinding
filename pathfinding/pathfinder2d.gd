@icon("res://editor/icons/navigation-arrow-fill.svg")
class_name Pathfinder2D
extends Node


enum SourcePathfindingMode {
	GROUPS_EXPLICIT,
	GROUPS_WITH_CHILDREN,
}


signal target_reached()


static var astar_grid_storage : Dictionary


@export_range(0.1, 1000.0, 0.01, "or_greater", "suffix:px") var target_desired_distance : float = 10.0

@export_group("Pathfinding")
@export var heuristic : AStarGrid2D.Heuristic
@export var diagonal_mode : AStarGrid2D.DiagonalMode
@export var simplify_path : bool = false
@export var allow_partial_path : bool = true

@export_group("Pathfinding Source")
@export var source_pathfinding_mode : SourcePathfindingMode
@export var source_pathfinding_group_name : StringName = &"pathfinding_source_group"

@export_group("Debug")
@export var debug_enabled : bool = false
@export var debug_waypoints_only : bool = false
@export var debug_path_line_color := Color.RED
@export var debug_path_line_width : float = 1.0


var target_position : Vector2 :
	get:
		return target_position
	set(value):
		if target_position != value:
			target_position = value
			if __astar_grid:
				__find_path()
		return


var __astar_grid : AStarGrid2D
var __pathfinding_layer : TileMapLayer
var __solid_cells : Array[Vector2i]

var __path_points : Array[Vector2i]
var __path_points_index : int = 0
var __target_reached : bool = true

var __debugger : PathfinderDebugger


@onready var parent2d : Node2D = get_parent()


func _ready() -> void:
	__init_pathfinding_layer()
	__astar_grid = __get_astar_grid_from_storage(source_pathfinding_group_name)
	if not __astar_grid:
		__init_astar_grid()
		__init_astar_options()
		__update_astar_grid()
	__init_debug()
	return


#region Initialization functions

func __init_pathfinding_layer() -> void:
	var pathfinding_source_layers : Array[TileMapLayer] = __get_pathfinding_source_layers()
	__pathfinding_layer = pathfinding_source_layers.front()
	__solid_cells = __find_solid_cells(pathfinding_source_layers)
	return


func __init_astar_grid() -> void:
	__astar_grid = AStarGrid2D.new()
	__astar_grid.region = __pathfinding_layer.get_used_rect()
	__astar_grid.cell_size = __pathfinding_layer.tile_set.tile_size
	return


func __init_astar_options() -> void:
	__astar_grid.default_compute_heuristic = heuristic
	__astar_grid.default_estimate_heuristic = heuristic
	__astar_grid.diagonal_mode = diagonal_mode
	__astar_grid.jumping_enabled = simplify_path
	return


func __init_debug() -> void:
	if debug_enabled:
		__debugger = PathfinderDebugger.new(debug_path_line_color, debug_path_line_width)
		add_child(__debugger, false, Node.INTERNAL_MODE_FRONT)
	return

#endregion


func get_path_points() -> Array[Vector2i]:
	return __path_points


func get_path_positions(from: int = 0, waypoints_only: bool = true) -> Array[Vector2]:
	var path_positions : Array[Vector2]
	while from < __path_points.size():
		path_positions.append(__point_to_position(__path_points[from]))
		from += 1
	if not waypoints_only:
		path_positions.push_front(parent2d.position)
		path_positions.push_back(target_position)
	return path_positions


func get_next_path_position() -> Vector2:
	var next_position : Vector2 = parent2d.position
	__update_path()
	if not __path_points.is_empty():
		if __path_points[__path_points_index] != __path_points.back():
			next_position = __point_to_position(__path_points[__path_points_index])
		else:
			next_position = target_position
	return next_position


func is_target_reached() -> bool:
	return __target_reached


func __update_astar_grid() -> void:
	__astar_grid.update()
	for cell : Vector2i in __solid_cells:
		__astar_grid.set_point_solid(cell, true)
	__add_astar_grid_to_storage(source_pathfinding_group_name, __astar_grid)
	return


func __find_path() -> void:
	var start_point : Vector2i = __position_to_point(parent2d.position)
	var final_point : Vector2i = __position_to_point(target_position)
	if __is_valid_destination_points(start_point, final_point):
		__path_points = __astar_grid.get_id_path(start_point, final_point, allow_partial_path)
		__path_points_index = 0
		__target_reached = false
		if debug_enabled:
			__debugger.draw_path(get_path_positions(__path_points_index, debug_waypoints_only))
	return


func __update_path() -> void:
	if __path_points_index < __path_points.size() - 1:
		if __path_points[__path_points_index] == __position_to_point(parent2d.position):
			__path_points_index += 1
		if debug_enabled:
			__debugger.draw_path(get_path_positions(__path_points_index, debug_waypoints_only))
	elif target_desired_distance >= parent2d.position.distance_to(target_position):
		__target_reached = true
		target_reached.emit()
	return


#region Utility functions

func __get_astar_grid_from_storage(key: String) -> AStarGrid2D:
	var astar_grid : AStarGrid2D
	if astar_grid_storage.has(key):
		astar_grid = astar_grid_storage[key]
	return astar_grid


func __add_astar_grid_to_storage(key: String, astar_grid: AStarGrid2D) -> void:
	astar_grid_storage[key] = astar_grid
	return


func __get_pathfinding_source_layers() -> Array[TileMapLayer]:
	var layers : Array[TileMapLayer]
	match source_pathfinding_mode:
		SourcePathfindingMode.GROUPS_EXPLICIT:
			layers.assign(get_tree().get_nodes_in_group(source_pathfinding_group_name))
		SourcePathfindingMode.GROUPS_WITH_CHILDREN:
			for source_node : Node in get_tree().get_nodes_in_group(source_pathfinding_group_name):
				for source_child : Node in source_node.get_children():
					if source_child is TileMapLayer:
						layers.append(source_child)
	return layers


func __find_solid_cells(layers: Array[TileMapLayer]) -> Array[Vector2i]:
	var solid_cells : Array[Vector2i]
	var main_layer : TileMapLayer = layers.pop_front()
	for layer : TileMapLayer in layers:
		for cell : Vector2i in layer.get_used_cells():
			if cell in main_layer.get_used_cells() and not solid_cells.has(cell):
				solid_cells.append(cell)
	return solid_cells


func __is_valid_destination_points(from: Vector2i, to: Vector2i) -> bool:
	return __astar_grid.is_in_boundsv(from) and __astar_grid.is_in_boundsv(to)


func __point_to_position(point: Vector2i) -> Vector2:
	return __pathfinding_layer.map_to_local(point)


func __position_to_point(position: Vector2) -> Vector2i:
	return __pathfinding_layer.local_to_map(position)

#endregion
