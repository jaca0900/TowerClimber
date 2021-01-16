extends KinematicBody2D

var velocity = Vector2(0,0);
var speed = 0;
var setSpeed = 0;
const SPEED_CAP = 1000;
const ACCELLERATION = 20;
const GRAVITY = 40;
const BASE_JUMP_FORCE = -950 ;
var currentDirection = "";
var isOnWall = false;
var previousClimberY;
var multiplier = 1;
var pointsNormal = 0;

signal points_added(points);

func setAnimationSpeed():
	var animationSpeed = speed/200;
	if animationSpeed < 5:
		animationSpeed = 5;

	$Sprite.frames.set_animation_speed("walk",  animationSpeed);
	pass

func setWalkingSpeed(direction, onWall):

	if direction == "right" && !isOnWall && currentDirection != direction:
		if speed < 0:
			speed = 0;
			pass

		if speed < SPEED_CAP:
			speed += ACCELLERATION;
	elif direction == "left" && !isOnWall && currentDirection != direction:
		if speed > 0:
			speed = 0;

		if speed > -SPEED_CAP:
			speed -= ACCELLERATION;

	if(onWall):
		speed = -speed;
		currentDirection = direction;
		isOnWall = onWall;
		yield(get_tree().create_timer(0.5), "timeout");
		isOnWall = !isOnWall;
		currentDirection = "";
		pass
	pass

func _physics_process(delta):
	var fallZone = get_node("../fallZone");
	var newLimitBottom = position.y + $Camera2D.get_viewport_rect().size.y * 0.75;

	if Input.is_action_pressed("right"):
		$Sprite.play("walk");
		$Sprite.flip_h = false;

		setWalkingSpeed("right", is_on_wall());

		setAnimationSpeed();
	elif Input.is_action_pressed("left"):
		$Sprite.play("walk");
		$Sprite.flip_h = true;

		setWalkingSpeed("left", is_on_wall());

		setAnimationSpeed();
	else:
		speed = lerp(speed, 0, 0.1);
		$Sprite.play("idle");

	if not is_on_floor():
		$Sprite.play("air");
	elif $Camera2D.limit_bottom > newLimitBottom:
		$Camera2D.limit_bottom = newLimitBottom;
		fallZone.position.y = newLimitBottom;

	if speed != setSpeed:
		velocity.x = speed;
		setSpeed = speed;
	elif !(speed == SPEED_CAP || speed == -SPEED_CAP):
		velocity.x = lerp(velocity.x, 0, 0.001);

	if is_on_floor():
		var newNormal = floor(abs(position.y / 35 - 57));

		if pointsNormal < newNormal:
			var newPoints = floor(abs(position.y / 35 - 57)) * multiplier;
			pointsNormal = newNormal;
			emit_signal("points_added", newPoints);

		if Input.is_action_just_pressed("jump"):

			var jump = BASE_JUMP_FORCE;

			if BASE_JUMP_FORCE > speed:
				$AnimationPlayer.play("superJump");
				jump = speed * 2;
				multiplier = 2;

			velocity.y = jump;
		else:
			multiplier = 1;
		pass

	velocity.y += GRAVITY;

	velocity = move_and_slide(velocity, Vector2.UP);

	if !currentDirection and isOnWall:
		isOnWall = false;

	pass

func _on_fallZone_body_entered(body):
	get_tree().change_scene("res://GameOver.tscn");
	pass


func _on_winZone_body_entered(body):
	get_tree().change_scene("res://GameWon.tscn");
	pass # Replace with function body.
