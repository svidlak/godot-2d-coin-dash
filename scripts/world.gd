extends Node

var screensize = Vector2(480, 720)

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene

var level = 1
var score = 0
var time_left = 30

func _ready():
	screensize = get_viewport().get_visible_rect().size
	set_process(false)

func end_game():
	set_process(false)
	$HUD.end_game()
	$EndSound.play()
	$GameTime.stop()
	$Player.end_game()
	
func start_new_game():
	get_tree().call_group("coin", "queue_free")
	get_tree().call_group("cactus", "queue_free")
	get_tree().call_group("powerup", "queue_free")

	level = 1
	score = 0
	time_left = 30
	
	$Player.start_game()
	$Player.position = Vector2(screensize.x /2,screensize.y/2)
	
	spawn_coins()
	set_process(true)
	
	$GameTime.start()
	
func spawn_coins():
	for n in level+4:
		spawn_coin()
		
func spawn_coin():
	var c = coin_scene.instantiate()
	c.position = Vector2(randi_range(0, screensize.x),randi_range(0, screensize.y))
	add_child(c)
	
func spawn_powerup():
	var c = powerup_scene.instantiate()
	c.position = Vector2(randi_range(0, screensize.x),randi_range(0, screensize.y))
	add_child(c)
	
func spawn_cactus():
	var c = cactus_scene.instantiate()
	c.position = Vector2(randi_range(0, screensize.x),randi_range(0, screensize.y))
	add_child(c)

func _process(delta):
	if time_left < 1:
		end_game()
		return
		
	if get_tree().get_nodes_in_group("coin").size() == 0:
		$LevelSound.play()
		level += 1
		time_left += 5
		spawn_coins()
		spawn_powerup()
		spawn_cactus()
		$Player.boost()
		$HUD.update_time(time_left)

func _on_player_pickup(type):
	score += 1
	if type == "coin":
		$HUD.update_score(score)
	if type == "powerup":
		$Player.temp_boost()


func _on_hud_start_game():
	start_new_game()

func _on_game_time_timeout():
	time_left -= 1
	$HUD.update_time(time_left)

func _on_player_end_game_signal():
	end_game()
