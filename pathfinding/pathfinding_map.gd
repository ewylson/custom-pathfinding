class_name PathfindingMap
extends RefCounted


var layer : TileMapLayer
var region : Rect2i
var cell_size : Vector2
var solid_cells : Array[Vector2i]


func _init(pathfinding_layer: TileMapLayer, impassable_cells: Array[Vector2i]) -> void:
	layer = pathfinding_layer
	region = pathfinding_layer.get_used_rect()
	cell_size = pathfinding_layer.tile_set.tile_size
	solid_cells = impassable_cells
	return
