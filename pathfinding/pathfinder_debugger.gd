@icon("res://editor/icons/2d/bug-beetle-fill.svg")
class_name PathfinderDebugger
extends Node2D


var line_color : Color
var line_width : float


var __positions : PackedVector2Array


func _init(path_line_color: Color = Color.RED, path_line_width: float = 1.0) -> void:
	line_color = path_line_color
	line_width = path_line_width
	return


func _draw() -> void:
	if __positions.size() > 1:
		draw_polyline(__positions, line_color, line_width)
	return


func draw_path(path___positions: Array[Vector2]) -> void:
	__positions = PackedVector2Array(path___positions)
	queue_redraw()
	return
