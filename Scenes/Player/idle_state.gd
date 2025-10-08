extends NodeState

@export var player:Player
@export var animated_sprite_2D: AnimatedSprite2D

func _on_process(_delta : float) -> void:
	animated()
	pass


func _on_physics_process(_delta : float) -> void: 
	player.define_player_orientation()
	animated()

func animated()->void:
	var name_animation =  player.get_orientation() +"_idle"
	#print(name_animation)
	animated_sprite_2D.play(name_animation)

func _on_next_transitions() -> void:
	player.define_player_orientation()
	if !player.has_reached_destination():
		#print("trying to walk")
		transition.emit("Walk")

func _on_enter() -> void:
	animated()

func _on_exit() -> void:
	pass
