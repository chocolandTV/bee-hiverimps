extends AudioStreamPlayer3D

func on_play_bee_sound():
	if playing:
		return
	play()