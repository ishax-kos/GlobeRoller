extends MeshInstance3D

var speed := 0.01
var do_rotate := false

var continent_transform : Node3D

@onready var base :Node= get_tree().current_scene

func _ready() -> void:
    speed_changed(0.1)
    %OnOff.button_pressed = false
    %LatSlider.value = 0.0
    %LonSlider.value = 0.5
    rotation.y = %LonSlider.value * TAU
    

func _process(delta: float) -> void:
    
    if do_rotate:
        rotation.y = wrapf(rotation.y + delta*speed*TAU, 0.0, TAU)
        %LonSlider.set_value_no_signal(rotation.y/TAU)

    #for handle in $Handles.get_children():
        #handle.get_node("Dot").transparency = handle_transparency


func speed_changed(value: float) -> void:
    speed = value
    if (speed != 0):
        %SpeedSlider.set_value_no_signal(log(absf(speed))/log(2.0))
        %RightLeft.set_pressed_no_signal(speed > 0.0)
    
    if !%SpeedTextEdit.has_focus():
        %SpeedTextEdit.text = str(speed)


func _new_speed_slider(value: float) -> void:
    if value == %SpeedSlider.min_value:
        speed_changed(0.0)
    value = pow(2.0, value)
    if !%RightLeft.button_pressed:
        value = -value
    speed_changed(value)
    %OnOff.set_pressed_no_signal(do_rotate)
    do_rotate = speed != 0


func _new_speed_text(new_text: String) -> void:
    if !new_text.is_valid_float():
        return
    speed_changed(new_text.to_float())
    %OnOff.set_pressed_no_signal(do_rotate)
    do_rotate = speed != 0
    

func _direction_toggled(direction: bool) -> void:
    speed_changed(absf(speed) * (float(direction) * 2.0 - 1.0))


func _on_off_toggled(toggled_on: bool) -> void:
    do_rotate = toggled_on


func _longitude_changed(value: float) -> void:
    %OnOff.button_pressed = false
    rotation.y = value * TAU

func _lattitude_changed(value: float) -> void:
    $"../CameraPivot".rotation.x = -value * TAU

func add_continent_handle(cont: Continent) -> Node3D:
    var node := preload("res://scenes/continent_handle.tscn").instantiate()
    node.rotation = -cont.location * TAU
    node.continent = cont
    $Handles.add_child(node)
    return node
    

#var timer := Timer.new()
var handle_transparency := 0.0

func show_handles():
    pass
    #timer.start(5.0)
    #await timer.timeout
    #var tween := create_tween()
    #var tweener := tween.tween_property(self, "handle_transparency", 1.0, 0.5)
    #await tweener.finished
    #tweener = tween.tween_property(self, "handle_transparency", 0.0, 0.5)
    


func _on_continent_added(_index: int) -> void:
    pass
    #add_continent_handle(base.continents[index])





func _on_speed_text_edit_text_changed(new_text: String) -> void:
    _new_speed_text(new_text)
    
