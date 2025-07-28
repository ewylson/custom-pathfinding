@icon("res://editor/icons/2d/skull-fill.svg")
class_name EnemyCharacter
extends Entity


const SPEED : float = 50.0


@export var movement_target : Node2D


@onready var pathfinder : Pathfinder2D = $Pathfinder2D


func _physics_process(_delta: float) -> void:
	pathfinder.target_position = movement_target.position
	
	var direction : Vector2 = position.direction_to(pathfinder.get_next_path_position())
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	velocity = direction * SPEED
	move_and_slide()
	
	return
