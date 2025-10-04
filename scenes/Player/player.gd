extends CharacterBody2D
class_name Player

@export var move_speed: float = 100

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var move_vector: Vector2 = Input.get_vector("move_left","move_right", "move_up", "move_down")
	velocity = Vector2(move_vector.x,0.0).normalized() * move_speed
	
	move_and_slide()
