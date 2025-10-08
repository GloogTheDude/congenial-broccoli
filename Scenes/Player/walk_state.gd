extends  NodeState

@export var player:Player
@export var animated_sprite_2D:AnimatedSprite2D
@export var speed: float = 50.0

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	player.define_player_orientation()
	animated()
	if(!player.has_reached_destination()):
		player.direction = (player.destination - player.global_position).normalized()
		player.velocity = player.direction * speed
		player.move_and_slide()

func animated()->void:
	var name_animation = player.get_orientation() +"_walk"
	#print(name_animation)
	if(name_animation!=animated_sprite_2D.animation):
		animated_sprite_2D.play(name_animation)
	


func _on_next_transitions() -> void:
	player.define_player_orientation()
	if player.has_reached_destination():
		#print("trying to go back to idle")
		if player.target == null:
			transition.emit("Idle")
	elif player.target:
		if player.global_position.distance_squared_to(player.target.global_position) < 250:
			match player.target.interactable_data.type:
				DataType.type_interactable.monster: 
					#transition.emit("Attack")
					transition.emit("Attack")
				DataType.type_interactable.breakable: 
					#transition.emit("Attack")
					transition.emit("Attack")
					print("should breaka breakable")
	

func _on_enter() -> void:
	pass


func _on_exit() -> void:
	player.velocity = Vector2.ZERO
