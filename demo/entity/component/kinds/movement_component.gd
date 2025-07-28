@icon("res://editor/icons/arrows-out-cardinal-fill.svg")
class_name MovementComponent
extends EntityComponent


const SPEED : float = 200.0


func _physics_process(_delta: float) -> void:
	var direction : Vector2 = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
	
	# Normalize diagonal movement to prevent faster diagonal speed.
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	owner_entity.velocity = direction * SPEED
	owner_entity.move_and_slide()
	
	return
