extends CanvasLayer

signal start_game

func update_score(score):
	$MarginContainer/Score.text = str(score)
	
func update_time(time):
	$MarginContainer/TimeLeft.text = str(time)
	
func _on_button_button_down():
	$GameText.hide()
	$Button.hide()
	start_game.emit()

func end_game():
	$GameText.text = "Game Over"
	$GameText.show()
	$EndGameTimer.start()

func _on_end_game_timer_timeout():
	$GameText.text = "Coin Dash"
	$Button.show()
	$EndGameTimer.stop()
