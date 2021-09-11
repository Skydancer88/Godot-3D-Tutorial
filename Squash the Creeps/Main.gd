extends Node

export (PackedScene) var mob_scene


func _ready():
	randomize()
	$UserInterface/Retry.hide()


func _on_MobTimer_timeout():
	# create mon instance in scene
	var mob =mob_scene.instance()
	
	# choose random start location on path
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# apply random offset
	mob_spawn_location.unit_offset = randf()
	
	# get player position
	var player_position = $Player.transform.origin
	
	
	add_child(mob)
	mob.initialize(mob_spawn_location.translation, player_position)
	
	# connect to score label
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")

func _on_Player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# restart current scene
		get_tree().reload_current_scene()
