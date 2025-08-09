extends Node


var __astar_grids : Dictionary


func get_astar_grid(key: String) -> AStarGrid2D:
	var astar_grid : AStarGrid2D
	if __astar_grids.has(key):
		astar_grid = __astar_grids[key]
	return astar_grid


func add_astar_grid(key: String, astar_grid: AStarGrid2D) -> void:
	__astar_grids[key] = astar_grid
	return
