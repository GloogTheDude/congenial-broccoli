extends NodeState

@export var player:CharacterBody2D
@export var animated_sprite_2D: AnimatedSprite2D

func _on_process(_delta : float) -> void:
	animated()
	pass


func _on_physics_process(_delta : float) -> void: 
	GameInputEvent.define_player_orientation(player)
	animated()

func animated()->void:
	var name_animation =  player.orientation +"_idle"
	#print(name_animation)
	animated_sprite_2D.play(name_animation)

func _on_next_transitions() -> void:
	GameInputEvent.define_player_orientation(player)
	if GameInputEvent.is_input(player):
		#print("trying to walk")
		transition.emit("Walk")

func _on_enter() -> void:
	animated()

func _on_exit() -> void:
	pass
