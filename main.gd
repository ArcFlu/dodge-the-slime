extends Node

@export var mob_scene: PackedScene
var score: int = 0
var high_score: int = load_high_score()

func save_high_score(score):
	var file = FileAccess.open("user://high_score.save", FileAccess.WRITE)
	if file:
		file.store_var(score)
		file.close()

func load_high_score() -> int:
	if FileAccess.file_exists("user://high_score.save"):
		var file = FileAccess.open("user://high_score.save", FileAccess.READ)
		if file:
			var score = file.get_var()
			file.close()
			return score
	return 0  # Default if no file exists

func _ready() -> void:
	if score > high_score:
		high_score = score
		$HUD.update_high_score(high_score)
		save_high_score(score)
	$BGM.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over():
	$BGM.stop()
	$HUD.show_game_over()
	$ScoreTimer.stop()
	for i in range(20): 
		var sound = $DeathSound.duplicate()
		add_child(sound)
		sound.pitch_scale = randf_range(0.8, 1.4)
		sound.play()
		await get_tree().create_timer(.2).timeout

func new_game():
	$DeathSound.stop()
	if !$BGM.playing:
		$BGM.play()
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)       
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	if score > high_score:
		high_score = score
		$HUD.update_high_score(high_score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
