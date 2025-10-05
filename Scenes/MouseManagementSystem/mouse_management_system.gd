extends Node2D

const INTERRACTABLE_MASK = 1 << 0 #layer1

var last_mouse_position: Vector2 = Vector2.INF
var target:Object


signal hover_enter
signal hover_exit
signal hover_stay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	if mouse_position == last_mouse_position:
		return
	last_mouse_position = mouse_position
	
	#préparer la requête "point" sous la souris
	var params := PhysicsPointQueryParameters2D.new()
	params.position = last_mouse_position
	params.collision_mask = INTERRACTABLE_MASK
	params.collide_with_areas = true
	params.collide_with_bodies = true
	
	#interroger le moteur: 
	var space := get_world_2d().direct_space_state
	var results := space.intersect_point(params, 32) #jusqu'à 32 hits
	
	#choisir la cible officiel
	var new_target = results[0].get("collider") if results.size() > 0 else null
	
	#gestion hover enter / exit
	if new_target != target:
		if target:
			_on_hover_exit(target)
		target = new_target
		if target:
			_on_hover_enter(target)
	
	
	# --- Callbacks simples (remplace par ta logique/émission de signaux) ---
func _on_hover_enter(target: Object) -> void:
	print("_on_hover_enter")
	# ex: highlight, curseur contextuel, label...
	pass

func _on_hover_exit(target: Object) -> void:
	# ex: retirer highlight
	print("_on_hover_exit")
	pass

func _on_selected(target: Object) -> void:
	# ex: émettre un signal "selected(target, position/anchor, radius)"
	pass
