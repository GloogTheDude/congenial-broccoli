extends NodeState

@export var player:Player
@export var animated_sprite_2D:AnimatedSprite2D
@export var speed: float = 50.0

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if !animated_sprite_2D.is_playing():
		player.define_player_orientation()
		if player.target:
			if player.global_position.distance_squared_to(player.target.global_position) < 25:
				transition.emit("Attack")
			else: transition.emit("Walk")
		else:
			transition.emit("Idle")

func _on_enter() -> void:
	print("i want to attack")
	player.velocity = Vector2.ZERO
	animated()
	


func _on_exit() -> void:
	pass

func animated()->void:
	var name_animation = player.get_orientation() +"_attack"
	
	if(name_animation!=animated_sprite_2D.animation):
		animated_sprite_2D.play(name_animation)
