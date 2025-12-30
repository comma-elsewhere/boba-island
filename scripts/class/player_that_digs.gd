class_name Player extends CharacterBody3D

@export var dirt_material = StandardMaterial3D
@export var plant_inside_material = StandardMaterial3D

var mesh_slicer = MeshSlicer.new()

# Movement vars
var speed
const CROUCH_SPEED = 3.0
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.8

const SENSITIVITY = 0.004 # Can be a globally controlled var

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

# Bool for if crouching
var is_crouched: bool = false

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var uncrouch: ShapeCast3D = $UncrouchCheck
@onready var csg_spawner: Marker3D = %CSGSpawner
@onready var ground_check: ShapeCast3D = %GroundCheck # Should only collide with the dirt layer
@onready var slicer: Marker3D = %Slicer


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animation.animation_finished.connect(_on_animation_done)
	add_child(mesh_slicer)
	
 #Crouch
func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("slice"):
		#_slice()
	#
	if ground_check.is_colliding():
		if event.is_action_pressed("interact"):
			_remove_dirt()
		if event.is_action_pressed("drop"):
			_build_dirt()
	
	if event.is_action_pressed("crouch") and !animation.is_playing():
		if is_crouched and !uncrouch.is_colliding():
			animation.play_backwards("crouch")
		else:
			animation.play("crouch")
			
# Head rotate and look around
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(90))
			
# Handle movement
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_crouched:
		velocity.y = JUMP_VELOCITY
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint") and !is_crouched:
		speed = SPRINT_SPEED
	elif is_crouched:
		speed = CROUCH_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

# Handle headbob
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

# Set crouch bool
func _on_animation_done(anim: StringName) -> void:
	if anim == "crouch":
		is_crouched = !is_crouched


func _remove_dirt() -> void:
	var csg_base = CSGSphere3D.new()
	csg_base.material = dirt_material
	get_tree().call_group("Combiner", "subtract_combine", csg_base)
	csg_base.global_position = csg_spawner.global_position
	csg_base.global_rotation = csg_spawner.global_rotation

func _build_dirt() -> void:
	var csg_base = CSGSphere3D.new()
	csg_base.material = dirt_material
	get_tree().call_group("Combiner", "union_combine", csg_base)
	csg_base.global_position = csg_spawner.global_position
	csg_base.global_rotation = csg_spawner.global_rotation

func _slice() -> void:
	for body in %SlicerArea.get_overlapping_bodies().duplicate():
		if body.has_method("return_objects"):
			var objects: Array = body.return_objects()
			var mesh_instance: MeshInstance3D = objects[0]
			#var collision_shape: CollisionShape3D = objects[1]
			
			var Transform = Transform3D.IDENTITY
			Transform.origin = mesh_instance.to_local((slicer.global_transform.origin))
			Transform.basis.x = mesh_instance.to_local((slicer.global_transform.basis.x+body.global_position))
			Transform.basis.y = mesh_instance.to_local((slicer.global_transform.basis.y+body.global_position))
			Transform.basis.z = mesh_instance.to_local((slicer.global_transform.basis.z+body.global_position))
			
			var meshes = mesh_slicer.slice_mesh(Transform,mesh_instance.mesh,plant_inside_material)

			mesh_instance.mesh = meshes[0]
			
			##generate collision
			#if len(meshes[0].get_faces()) > 2:
				#collision_shape.shape = meshes[0].create_convex_shape()
				
			body.death_animation()
