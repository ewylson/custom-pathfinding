@icon("res://editor/icons/2d/bug-beetle-fill.svg")
class_name PathfinderDebugger
extends Node2D


var positions : PackedVector2Array

var line_color : Color
var line_width : float


func _init(path_line_color: Color = Color.RED, path_line_width: float = 1.0) -> void:
	line_color = path_line_color
	line_width = path_line_width
	return


func _draw() -> void:
	if positions.size() > 1:
		draw_polyline(positions, line_color, line_width)
	return


func draw_path(path_positions: Array[Vector2]) -> void:
	positions = PackedVector2Array(path_positions)
	queue_redraw()
	return
