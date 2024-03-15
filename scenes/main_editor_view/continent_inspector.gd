extends PanelContainer

var continent : Continent
var entry : int
@onready var base :Node= get_tree().current_scene
@onready var lat_node :SpinBox= $VBoxContainer/HBoxLat/SpinBox
@onready var lon_node :SpinBox= $VBoxContainer/HBoxLon/SpinBox
@onready var rot_node :SpinBox= $VBoxContainer/HBoxRot/SpinBox
@onready var imgx_node :SpinBox= $VBoxContainer/HBoxCenterX/SpinBox
@onready var imgy_node :SpinBox= $VBoxContainer/HBoxCenterY/SpinBox
@onready var imgr_node :SpinBox= $VBoxContainer/HBoxRotaion2/SpinBox
@onready var scale_node :SpinBox= $VBoxContainer/HBoxScale/SpinBox
@onready var use_radians_node :CheckBox= $VBoxContainer/UseRadians

func _ready() -> void:
    update_angle_mode()
    hide()
    
    
    var popup :PopupMenu= $VBoxContainer/HBoxProjection/MenuButton.get_popup()
    for type in Continent.Projection_type.values():
        popup.add_icon_radio_check_item(
            Continent.projection_icons[type], 
            Continent.projection_names[type],
            type
        )
    popup.index_pressed.connect(_projection_selected)

func get_modifier() -> float:
    if use_radians_node.button_pressed:
        return TAU
    else:
        return 360.0


func update_menu() -> void:
    var modifier := get_modifier()
    lat_node.set_value_no_signal(continent.latitude * modifier)
    lon_node.set_value_no_signal(continent.longitude * modifier)
    rot_node.set_value_no_signal(continent.rotation * modifier)
    imgx_node.set_value_no_signal(continent.image_offset.x)
    imgy_node.set_value_no_signal(continent.image_offset.y)
    imgr_node.set_value_no_signal(continent.image_rotation * modifier)
    scale_node.set_value_no_signal(continent.scale)
    

func _on_use_radians_toggled(toggled_on: bool) -> void:
    update_menu()
    update_angle_mode()
    
func update_angle_mode() -> void:
    if use_radians_node.button_pressed:
        lat_node.min_value = -TAU/4.0
        lat_node.max_value = TAU/4.0
        lat_node.custom_arrow_step = 0.001
        lon_node.min_value = -TAU/2.0
        lon_node.max_value = TAU/2.0
        lon_node.custom_arrow_step = 0.001
        rot_node.min_value = -TAU/2.0
        rot_node.max_value = TAU/2.0
        rot_node.custom_arrow_step = 0.001
        imgr_node.min_value = -TAU/2.0
        imgr_node.max_value = TAU/2.0
        imgr_node.custom_arrow_step = 0.001
    else:
        lat_node.value = roundf(lat_node.value)
        lon_node.value = roundf(lon_node.value)
        rot_node.value = roundf(rot_node.value)
        lat_node.min_value = -90
        lat_node.max_value = 90
        lat_node.custom_arrow_step = 5.0
        lon_node.min_value = -180
        lon_node.max_value = 180
        lon_node.custom_arrow_step = 5.0
        rot_node.min_value = -180
        rot_node.max_value = 180
        rot_node.custom_arrow_step = 1
        imgr_node.min_value = -180
        imgr_node.max_value = 180
        imgr_node.custom_arrow_step = 1
        


func _lat_changed(value: float) -> void:
    continent.latitude = lat_node.value / get_modifier()
    base.continent_changed.emit(entry)

func _lon_changed(value: float) -> void:
    continent.longitude = lon_node.value / get_modifier()
    base.continent_changed.emit(entry)

func _rot_changed(value: float) -> void:
    continent.rotation  = rot_node.value / get_modifier()
    base.continent_changed.emit(entry)

func _scale_changed(value: float) -> void:
    continent.scale = value
    base.continent_changed.emit(entry)


func _continent_selected(index: int) -> void:
    var cont: Continent= null
    if index != -1: 
        cont = base.continents[index]
    entry = index
    call_deferred(&"set_continent", cont)


func set_continent(cont: Continent) -> void:
    continent = cont
    if cont:
        update_menu()
        $VBoxContainer/HBoxContainer/Label.text = cont.name
        var mb :MenuButton= $VBoxContainer/HBoxProjection/MenuButton
        mb.text = Continent.projection_names[continent.projection]
        mb.get_popup().set_item_checked(cont.projection, true)
        show()
    else:
        hide()
    

func _on_continent_changed(index: int) -> void:
    if index == base.selected || index == -1:
        update_menu()


func _center_x_changed(value: float) -> void:
    continent.image_offset.x = value
    base.continent_changed.emit(entry)


func _center_y_changed(value: float) -> void:
    continent.image_offset.y = value
    base.continent_changed.emit(entry)
    

func _projection_selected(value: int) -> void:
    var mb :MenuButton= $VBoxContainer/HBoxProjection/MenuButton
    for i in continent.Projection_type.size():
        mb.get_popup().set_item_checked(i, i == value)
    continent.projection = value
    base.continent_changed.emit(entry)
    mb.text = Continent.projection_names[value]
    

func _on_base_continent_removed(index: int) -> void:
    if index == base.selected:
        entry = -1
        set_continent(null)
        

func _rotation2_changed(value: float) -> void:
    continent.image_rotation = imgr_node.value / get_modifier()
    base.continent_changed.emit(entry)


func _on_base_continents_reload() -> void:
    _continent_selected(-1)


func _on_menu_button_about_to_popup() -> void:
    _projection_selected(continent.projection)
