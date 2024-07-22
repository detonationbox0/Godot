extends Area2D

# How fast the player will move (pixels/sec)
@export var speed = 400
var screen_size

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1 # (0, +1)
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 # (0, -1)
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1 # (-1, 0)
	if Input.is_action_pressed("move_down"):
		velocity.y += 1 # (+1, 0)
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		print(velocity)
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		# print("velocity.x:", velocity.x, "flip?", velocity.x < 0)
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	# Reset to standing when not pressing anything
	if velocity == Vector2.ZERO:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
		
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_area_entered(area):
	hide()
	hit.emit()
	
	$CollisionShape2D.set_deferred("disabled", true)
	
