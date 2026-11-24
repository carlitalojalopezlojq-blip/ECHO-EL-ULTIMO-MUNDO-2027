extends CharacterBody3D

const SPEED = 6.0
const JUMP_VELOCITY = 5.0
const GRAVITY = 15.0

var move_input = Vector2.ZERO

func _ready():
    name = "ECHO_01"

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= GRAVITY * delta

    var input_vector = Vector2.ZERO

    if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
        input_vector.y -= 1.0
    if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
        input_vector.y += 1.0
    if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
        input_vector.x -= 1.0
    if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
        input_vector.x += 1.0

    input_vector += move_input
    input_vector = input_vector.limit_length(1.0)

    var direction = Vector3(input_vector.x, 0, input_vector.y)

    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED

    if direction.length() > 0.1:
        look_at(global_position + direction, Vector3.UP)

    if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
        velocity.y = JUMP_VELOCITY

    move_and_slide()
