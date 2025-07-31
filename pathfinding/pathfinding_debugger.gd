@icon("res://editor/icons/2d/bug-beetle-fill.svg")
class_name PathfindingDebugger
extends Node2D


var points : PackedVector2Array

var line_color : Color
var line_width : float


func _init(path_line_color: Color = Color.RED, path_line_width: float = 1.0) -> void:
	line_color = path_line_color
	line_width = path_line_width
	return


func _draw() -> void:
	if points.size() > 2:
		draw_polyline(points, line_color, line_width)
	return
