extends CharacterBody3D

# Plane controls: WASDQE for dimensional control, Shift/Ctrl to throttle up and down

@export var max_speed: float = 60.0
@export var acceleration: float = 15.0
@export var throttle_rate: float = 0.4
@export var pitch_rate: float = 1.2
@export var roll_rate: float = 2.0
@export var yaw_rate: float = 0.6

var throttle: float = 0.0
var speed: float = 0.0

func _physics_process(delta: float) -> void:
	_handle_throttle(delta)
	_handle_rotation(delta)
	_handle_movement(delta)

func _handle_throttle(delta: float) -> void:
	throttle += Input.get_axis("throttle_down", "throttle_up") * throttle_rate * delta
	throttle = clampf(throttle, 0.0, 1.0)

func _handle_rotation(delta: float) -> void:
	var pitch: float = Input.get_axis("pitch_down", "pitch_up")
	var roll: float = Input.get_axis("roll_left", "roll_right")
	var yaw: float = Input.get_axis("yaw_left", "yaw_right")
	
	rotate_object_local(Vector3.RIGHT, pitch * pitch_rate * delta)
	rotate_object_local(Vector3.FORWARD, roll * roll_rate * delta)
	rotate_object_local(Vector3.UP, yaw * yaw_rate * delta) # TODO figure out how the yaw works
	
	transform.basis = transform.basis.orthonormalized()

func _handle_movement(delta: float) -> void:
	var target_speed: float = throttle * max_speed
	speed = move_toward(speed, target_speed, acceleration * delta)
	
	velocity = -global_transform.basis.z * speed
	move_and_slide()
