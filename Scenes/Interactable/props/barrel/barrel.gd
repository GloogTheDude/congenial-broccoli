extends StaticBody2D

@onready var label: Label = $Label
@onready var interactable_component: InteractableComponent = $InteractableComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = interactable_component.interactable_data.interactable_name
	label.hide()
	interactable_component.enter_hovered.connect(on_enter_hovered)
	interactable_component.exit_hovered.connect(on_exit_hovered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_enter_hovered()->void:
	label.show()

func on_exit_hovered()->void:
	print("exit signal heard")
	label.hide()
