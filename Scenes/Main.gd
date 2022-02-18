extends Node

export (PackedScene) var mob_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	$UserInterface/Retry.hide()
	randomize()

func _on_Timer_timeout():
	var mob = mob_scene.instance()
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()
	var player_position = $Player.transform.origin
	add_child(mob)
	mob.initialize(mob_spawn_location.translation, player_position)
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")


func _on_Player_hit():
	$Timer.stop()
	$UserInterface/Retry.show()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
