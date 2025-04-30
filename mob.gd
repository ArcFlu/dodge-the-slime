extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = self.linear_velocity
	
	$AnimatedSprite2D.play()

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "lookRight" if velocity.x > 0 else "lookLeft"
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "lookDown" if velocity.y > 0 else "lookUp"

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
