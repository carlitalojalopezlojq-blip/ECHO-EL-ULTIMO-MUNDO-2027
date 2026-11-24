extends Node3D

const PLAYER_SCRIPT = preload("res://scripts/player/Player.gd")

func _ready():
    create_environment()
    create_ground()
    create_landscape()
    create_player()
    print("ECHO 2027: mundo inicial cargado")

func create_environment():
    var world_env = WorldEnvironment.new()
    var environment = Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color(0.025, 0.07, 0.12)
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.45, 0.65, 0.75)
    environment.ambient_light_energy = 0.8
    world_env.environment = environment
    add_child(world_env)

    var sun = DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -35, 0)
    sun.light_energy = 1.2
    add_child(sun)

func create_ground():
    var ground = MeshInstance3D.new()
    var mesh = PlaneMesh.new()
    mesh.size = Vector2(120, 120)
    ground.mesh = mesh

    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.08, 0.19, 0.14)
    material.roughness = 1.0
    ground.material_override = material
    add_child(ground)

    var body = StaticBody3D.new()
    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(120, 1, 120)
    collision.shape = shape
    collision.position.y = -0.5
    body.add_child(collision)
    add_child(body)

func create_landscape():
    for i in range(32):
        var x = randf_range(-48, 48)
        var z = randf_range(-48, 48)

        if abs(x) < 7 and abs(z) < 7:
            continue

        create_tree(Vector3(x, 0, z))

    for i in range(22):
        var rock = MeshInstance3D.new()
        var rock_mesh = SphereMesh.new()
        rock_mesh.radius = randf_range(0.5, 1.5)
        rock_mesh.height = rock_mesh.radius * 1.5
        rock.mesh = rock_mesh
        rock.position = Vector3(
            randf_range(-50, 50),
            0.3,
            randf_range(-50, 50)
        )
        var rock_mat = StandardMaterial3D.new()
        rock_mat.albedo_color = Color(0.18, 0.24, 0.28)
        rock.material_override = rock_mat
        add_child(rock)

func create_tree(pos: Vector3):
    var trunk = MeshInstance3D.new()
    var trunk_mesh = CylinderMesh.new()
    trunk_mesh.top_radius = 0.18
    trunk_mesh.bottom_radius = 0.35
    trunk_mesh.height = 3.0
    trunk.mesh = trunk_mesh
    trunk.position = pos + Vector3(0, 1.5, 0)

    var bark = StandardMaterial3D.new()
    bark.albedo_color = Color(0.18, 0.12, 0.10)
    trunk.material_override = bark
    add_child(trunk)

    var leaves = MeshInstance3D.new()
    var leaf_mesh = SphereMesh.new()
    leaf_mesh.radius = 1.4
    leaves.mesh = leaf_mesh
    leaves.position = pos + Vector3(0, 3.4, 0)

    var leaf_mat = StandardMaterial3D.new()
    leaf_mat.albedo_color = Color(0.08, 0.55, 0.34)
    leaf_mat.emission_enabled = true
    leaf_mat.emission = Color(0.02, 0.15, 0.08)
    leaves.material_override = leaf_mat
    add_child(leaves)

func create_player():
    var player = CharacterBody3D.new()
    player.set_script(PLAYER_SCRIPT)
    player.position = Vector3(0, 1, 0)

    var body_mesh = MeshInstance3D.new()
    var capsule = CapsuleMesh.new()
    capsule.radius = 0.4
    capsule.height = 1.8
    body_mesh.mesh = capsule
    body_mesh.position.y = 0.9

    var suit = StandardMaterial3D.new()
    suit.albedo_color = Color(0.75, 0.82, 0.88)
    body_mesh.material_override = suit
    player.add_child(body_mesh)

    var visor = MeshInstance3D.new()
    var visor_mesh = SphereMesh.new()
    visor_mesh.radius = 0.23
    visor_mesh.height = 0.25
    visor.mesh = visor_mesh
    visor.position = Vector3(0, 1.35, -0.28)

    var visor_mat = StandardMaterial3D.new()
    visor_mat.albedo_color = Color(0.0, 0.8, 1.0)
    visor_mat.emission_enabled = true
    visor_mat.emission = Color(0.0, 0.5, 1.0)
    visor.material_override = visor_mat
    player.add_child(visor)

    var collision = CollisionShape3D.new()
    var shape = CapsuleShape3D.new()
    shape.radius = 0.4
    shape.height = 1.8
    collision.shape = shape
    collision.position.y = 0.9
    player.add_child(collision)

    var camera = Camera3D.new()
    camera.position = Vector3(0, 3.2, 7)
    camera.rotation_degrees.x = -18
    camera.current = true
    player.add_child(camera)

    add_child(player)
