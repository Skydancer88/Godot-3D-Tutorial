extends KinematicBody

# min speed of mob in metre/s
export var min_speed =  10
# max speed of mob in metre/s
export var max_speed = 18

var velocity = Vector3.ZERO

signal squashed


func _physics_process(delta):
	move_and_slide(velocity)

func initialize(start_position, player_position):
	translation = start_position
	# turn mob to look at player
	look_at(player_position, Vector3.UP)
	#rotate randomly
	rotate_y(rand_range(-PI / 4, PI / 4))
	
	# randomise speed
	var random_speed = rand_range(min_speed, max_speed)
	# calculate forward velocity
	velocity = Vector3.FORWARD * random_speed
	# rotate based on y rotation
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.playback_speed = random_speed / min_speed

# destroy mob when screen exited
func _on_VisibilityNotifier_screen_exited():
	queue_free()

func squash():
	emit_signal("squashed")
	queue_free()
