extends KinematicBody

# player movement speed metre/s
export var speed = 14
# gravity in metre/s squared
export var fall_accelleration = 75
# jump power
export var jump_power = 20
# bounce power
export var bounce_power = 16

var velocity = Vector3.ZERO

signal hit

func _ready():
	pass

# called every frame
func _physics_process(delta):
	# store input direction
	var direction = Vector3.ZERO
	
	# check for move input and update direction
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	# normalise movement speed
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP) 
		$AnimationPlayer.playback_speed = 4
	else:
		$AnimationPlayer.playback_speed = 1
	
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_power
	
	# horizontal velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	# vertical velocity
	velocity.y -= fall_accelleration * delta
	
	# jump
	if is_on_floor() and  Input.is_action_just_pressed("jump"):
		velocity.y += jump_power
	# move character
	velocity = move_and_slide(velocity, Vector3.UP)
	
	for index in range(get_slide_count()):
		# check collisions in frame
		var collision = get_slide_collision(index)
		# if collided with monster
		if collision.collider.is_in_group("mob"):
			var mob = collision.collider
			# check if hitting from above
			if Vector3.UP.dot(collision.normal) > 0.1:
				# squash mob
				mob.squash()
				velocity.y = bounce_power

func die():
	emit_signal("hit")
	queue_free()

func _on_MobDetector_body_entered(body):
	die()
