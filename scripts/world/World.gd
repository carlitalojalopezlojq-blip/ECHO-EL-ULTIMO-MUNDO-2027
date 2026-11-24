extends Node3D

const PLAYER_SCRIPT = preload("res://scripts/player/Player.gd")

var selection_ui: Control

func _ready():
    randomize()
    create_environment()
    create_ground()
    create_landscape()
    show_character_selection()
    print("ECHO 2027: mundo preparado")

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
            randf_range(-50, 50), 0.3, randf_range(-50, 50)
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

func show_character_selection():
    selection_ui = Control.new()
    selection_ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(selection_ui)

    var background = ColorRect.new()
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.color = Color(0.015, 0.04, 0.07, 0.96)
    selection_ui.add_child(background)

    var panel = VBoxContainer.new()
    panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    panel.custom_minimum_size = Vector2(340, 300)
    panel.add_theme_constant_override("separation", 18)
    selection_ui.add_child(panel)

    var title = Label.new()
    title.text = "ECHO: EL ULTIMO MUNDO"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 25)
    panel.add_child(title)

    var subtitle = Label.new()
    subtitle.text = "ELIGE A TU EXPLORADOR"
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    panel.add_child(subtitle)

    var male_button = Button.new()
    male_button.text = "JUGAR CON GIANCARLOS"
    male_button.custom_minimum_size = Vector2(320, 60)
    male_button.pressed.connect(start_game.bind("GIANCARLOS"))
    panel.add_child(male_button)

    var female_button = Button.new()
    female_button.text = "JUGAR CON CARLITA LOJA"
    female_button.custom_minimum_size = Vector2(320, 60)
    female_button.pressed.connect(start_game.bind("Carlita Loja"))
    panel.add_child(female_button)

    var details = Label.new()
    details.text = "GIANCARLOS y Carlita Loja\n22 años cada uno\nEnamorados desde el 15 de enero de 2026"
    details.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    details.add_theme_font_size_override("font_size", 14)
    panel.add_child(details)

func start_game(selected_name: String):
    selection_ui.queue_free()

    var companion_name = "Carlita Loja" if selected_name == "GIANCARLOS" else "GIANCARLOS"

    var selected_color = Color(0.75, 0.82, 0.88) if selected_name == "GIANCARLOS" else Color(0.85, 0.68, 0.82)
    var companion_color = Color(0.85, 0.68, 0.82) if companion_name == "Carlita Loja" else Color(0.75, 0.82, 0.88)

    var protagonist = create_character(
        selected_name, Vector3(0, 1, 0), selected_color, false
    )

    create_character(
        companion_name, Vector3(2, 1, 2),
        companion_color, true, protagonist
    )

    print("Protagonista: ", selected_name)
    print("Acompanante: ", companion_name)

func create_character(character_name: String, spawn: Vector3, suit_color: Color, companion: bool, target: CharacterBody3D = null) -> CharacterBody3D:
    var character = CharacterBody3D.new()
    character.set_script(PLAYER_SCRIPT)
    character.display_name = character_name
    character.is_companion = companion
    character.follow_target = target
    character.position = spawn
    character.name = character_name.replace(" ", "_")

    var body_mesh = MeshInstance3D.new()
    var capsule = CapsuleMesh.new()
    capsule.radius = 0.4
    capsule.height = 1.8
    body_mesh.mesh = capsule
    body_mesh.position.y = 0.9

    var suit = StandardMaterial3D.new()
    suit.albedo_color = suit_color
    body_mesh.material_override = suit
    character.add_child(body_mesh)

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
    character.add_child(visor)

    var name_label = Label3D.new()
    name_label.text = character_name + " - 22"
    name_label.position.y = 2.2
    name_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    character.add_child(name_label)

    var collision = CollisionShape3D.new()
    var shape = CapsuleShape3D.new()
    shape.radius = 0.4
    shape.height = 1.8
    collision.shape = shape
    collision.position.y = 0.9
    character.add_child(collision)

    if not companion:
        var camera = Camera3D.new()
        camera.position = Vector3(0, 3.2, 7)
        camera.rotation_degrees.x = -18
        camera.current = true
        character.add_child(camera)

    add_child(character)
    return character
