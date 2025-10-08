class_name MouseManagementSystem
extends Node2D

const INTERRACTABLE_MASK = 1 << 0 #layer1

var last_mouse_position: Vector2 = Vector2.INF
var last_emitted_position: Vector2 = Vector2.INF
var last_emitted_target:InteractableComponent
var target:InteractableComponent

var lmb_is_input:bool = false
var can_get_target:bool = true
var is_target_locked: bool = true
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
	params.collide_with_bodies = false
	
	#interroger le moteur: 
	var space := get_world_2d().direct_space_state
	var results := space.intersect_point(params, 32) #jusqu'à 32 hits
	
	#choisir la cible officiel
	
	# --- Normalisation de la cible ---
	var new_target: Node = null
	for hit in results:
		var collider = hit.get("collider")
		if not collider:
			continue

		# Si c’est déjà un interactable -> parfait
		if collider.is_in_group("interactable"):
			new_target = collider
			break

		# Sinon, on remonte l'arborescence (jusqu’à trouver un parent interactable)
		var parent = collider.get_parent()
		while parent and not parent.is_in_group("interactable"):
			parent = parent.get_parent()
		if parent and parent.is_in_group("interactable"):
			new_target = parent
			break
	# Si aucun interactable trouvé -> new_target restera null
	
	#gestion hover enter / exit
	if new_target != target:
		if can_get_target and  !is_target_locked:
			if target:
				_on_hover_exit()
			target = new_target
			if target:
				_on_hover_enter()
				
	if lmb_is_input:
		left_clicking()
	
	# --- Callbacks simples (remplace par ta logique/émission de signaux) ---
func _on_hover_enter() -> void:
	
	if target.is_in_group("interactable"):
		print("_on_hover_enter grp interactable")
		print('interractable found')
		var data:InteractableData = target.interactable_data
		print("target: ",data.interactable_name)
		print("type = ", DataType.type_interactable.find_key(data.type))
		print("target id: ",data.id)
		target.emit_signal("enter_hovered")

func _on_hover_exit() -> void:
	# ex: retirer highlight
	
	if target.is_in_group("interactable"):
		print("_on_hover_exit grp interactable")
		print('interractable found')
		var data:InteractableData = target.interactable_data
		print("target: ",data.interactable_name)
		print("type = ", DataType.type_interactable.find_key(data.type))
		print("target id: ",data.id)
		target.emit_signal("exit_hovered")
	target = null

func _on_selected(target: Object) -> void:
	# ex: émettre un signal "selected(target, position/anchor, radius)"
	if target.is_in_group("interactable"):
		target.emit_signal("selected")
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Action_Button"):
		lmb_is_input= true
		left_clicking()
	if event.is_action_released("Action_Button"):
		lmb_is_input=false	
		can_get_target = true
		is_target_locked = false
		MyEventBus.lmb_released.emit()
	get_viewport().set_input_as_handled()


func left_clicking()->void: 
	var mouse_pos = get_global_mouse_position()

	if target == null:
		if mouse_pos.distance_squared_to(last_emitted_position) > 9.0 and !is_target_locked:
			print("no target, should trigger a walk to destination")
			var destination = get_global_mouse_position()
			last_emitted_position = destination
			MyEventBus.clicked_on_ground.emit(destination)
			can_get_target = false
	elif target.is_in_group("interactable"):
		if target != last_emitted_target:
			last_emitted_target = target
			MyEventBus.clicked_on_interactable.emit(target) 
			is_target_locked  = true
			_on_selected(target)
