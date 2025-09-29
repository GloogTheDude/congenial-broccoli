class_name GameInputEvent

static var direction:Vector2

static func define_player_orientation(player:CharacterBody2D)->void:
	if Input.is_action_pressed("Action_Button"):
		#définition d'une deadzone afin d'éviter le "Jitter"
		const DEADZONE:float = 5
		
		#récupérer position souris 
		#print("enter define_player_orientation")
		var mouse_position = player.get_global_mouse_position()
		#print("this is mouse_position: ", mouse_position)
		
		#calcule de la direction non normaliser.
		direction = (mouse_position)- player.global_position
		
		if direction.length()<=DEADZONE:
			return
		
		#snap en -1/0/1 par composante du vecteur
		var x:int = 0
		var y:int = 0
		if absf(direction.x) > DEADZONE:
			x = 1 if direction.x > 0.0 else -1
		if absf(direction.y) > DEADZONE:
			y = 1 if direction.y > 0.0 else -1
		var d := Vector2(x, y)
		player.direction = direction.normalized()
		#print("this is direction: ", direction)
		
		# map Vector2 -> code orientation
		
		match d:
			Vector2( 1,  0): player.orientation= "E"
			Vector2( 1, -1): player.orientation= "NE"
			Vector2( 0, -1): player.orientation= "N"
			Vector2(-1, -1): player.orientation= "NW"
			Vector2(-1,  0): player.orientation= "W"
			Vector2(-1,  1): player.orientation= "SW"
			Vector2( 0,  1): player.orientation= "S"
			Vector2( 1,  1): player.orientation= "SE"
		return
	else:
		player.direction = Vector2.ZERO	

static func is_input(player:CharacterBody2D)->bool:
	if player.direction == Vector2.ZERO:
		return false
	else:
		return true
