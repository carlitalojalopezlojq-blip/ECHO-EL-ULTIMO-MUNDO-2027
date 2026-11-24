extends CharacterBody3D

const SPEED = 6.0
const JUMP_VELOCITY = 5.0
const GRAVITY = 15.0

var display_name = "GIANCARLOS"
var is_companion = false
var follow_target: CharacterBody3D = null

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= GRAVITY * delta

    var direction = Vector3.ZERO

    if is_companion and is_instance_valid(follow_target):
        var target_direction = follow_target.global_position - global_position
        target_direction.y = 0

        if target_direction.length() > 2.5:
            direction = target_direction.normalized()
    elif not is_companion:
        var input_vector = Vector2.ZERO

        if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
            input_vector.y -= 1
        if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
            input_vector.y += 1
        if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
            input_vector.x -= 1
        if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
            input_vector.x += 1

        input_vector = input_vector.normalized()
        direction = Vector3(input_vector.x, 0, input_vector.y)

        if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
            velocity.y = JUMP_VELOCITY

    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED

    if direction.length() > 0.1:
        look_at(global_position + direction, Vector3.UP)

    move_and_slide()
