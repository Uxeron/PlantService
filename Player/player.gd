extends RigidBody2D
class_name PhysicalCharacter

@export var walking_speed: float = 100.0

@export var animation_speed: float = 0.2
var animation_timer: Timer
@onready var sprite: Sprite2D = $Sprite2D

var accumulated_rotation: float = 0.0
var accumulated_movement: Vector2 = Vector2.ZERO

var movement_direction_map: Dictionary = {
	"move_forward": Vector2.UP,
	"move_left": Vector2.LEFT,
	"move_right": Vector2.RIGHT,
	"move_back": Vector2.DOWN,
}

func animate() -> void:
	if sprite.frame + 1 >= sprite.vframes * sprite.hframes:
		sprite.frame = 0
	else:
		sprite.frame += 1

func _ready() -> void:
	animation_timer = Timer.new()
	animation_timer.one_shot = true
	animation_timer.timeout.connect(animate)
	add_child(animation_timer)

func _process(delta: float) -> void:
	if accumulated_movement != Vector2.ZERO:
		if animation_timer.is_stopped():
			animation_timer.start(animation_speed)
	else:
		if not animation_timer.is_stopped():
			animation_timer.stop()
			sprite.frame = 0

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
