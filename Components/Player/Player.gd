extends KinematicBody

#metri per secondi
export var speed = 14
#metri per secondi quadrati
export var fall_acceleration = 75
export var jump_impulse = 20
export var bounce_impulse = 16

var velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse 
	for ix in range(get_slide_count()):
		var collision = get_slide_collision(ix)
		if collision.collider.is_in_group("mob"):
			var mob = collision.collider
			if Vector3.UP.dot(collision.normal) > 0.1:
				mob.squash()
				velocity.y = bounce_impulse
