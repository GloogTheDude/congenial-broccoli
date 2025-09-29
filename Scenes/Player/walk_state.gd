extends  NodeState

@export var player:CharacterBody2D
@export var animated_sprite_2D:AnimatedSprite2D
@export var speed: int = 50

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	GameInputEvent.define_player_orientation(player)
	animated()
	player.velocity = player.direction * speed
	player.move_and_slide()

func animated()->void:
	var name_animation = player.orientation +"_walk"
	#print(name_animation)
	animated_sprite_2D.play(name_animation)
	


func _on_next_transitions() -> void:
	GameInputEvent.define_player_orientation(player)
	if !GameInputEvent.is_input(player):
		print("trying to go back to idle")
		transition.emit("Idle")

func _on_enter() -> void:
	pass


func _on_exit() -> void:
	pass
