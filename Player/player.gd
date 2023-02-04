extends RigidBody2D
class_name PhysicalCharacter

@export var walking_speed: float = 30.0

var accumulated_rotation: float = 0.0
var accumulated_movement: Vector2 = Vector2.ZERO

var movement_direction_map: Dictionary = {
	"move_forward": Vector2.UP,
	"move_left": Vector2.LEFT,
	"move_right": Vector2.RIGHT,
	"move_back": Vector2.DOWN,
}

func _physics_process(delta: float) -> void:
	for direction in movement_direction_map.keys():
		if not Input.is_action_pressed(direction):
			continue
		
		accumulated_movement += movement_direction_map[direction].rotated(rotation) * walking_speed * delta

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.transform = Transform2D(global_rotation + accumulated_rotation, global_position + accumulated_movement)
	
	accumulated_rotation = 0.0
	accumulated_movement = Vector2.ZERO
	state.linear_velocity = Vector2.ZERO
	state.angular_velocity = 0.0
