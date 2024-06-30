extends Area2D

signal pickup
signal end_game_signal

var move_speed = 350
var screensize = Vector2(480, 720)
var boostSpeedPercent = 0

func _process(delta):
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	position += velocity * move_speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func _on_area_entered(area: Area2D):
	if area.is_in_group("coin"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerup"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("cactus"):
		end_game_signal.emit()
		end_game()

func end_game():
	set_process(false)
	$AnimatedSprite2D.play("hurt")
	
func start_game():
	$Trail.player = self
	self.show()
	set_process(true)
	
func temp_boost():
	$Trail.show()
	boostSpeedPercent = 0.25 * move_speed
	move_speed += boostSpeedPercent
	$BoostTimeout.start()
	
func boost():
	move_speed += 0.10 * move_speed

func _on_boost_timeout_timeout():
	$Trail.hide()
	move_speed -= boostSpeedPercent

func _on_trail_tree_entered():
	$Trail.player = self
