extends SubViewport

@onready var timer :Timer= $Timer
var last_scale : float = 0.5
@onready var cont_list :Control= $ContinentList
@onready var base :Node= get_tree().current_scene


func _process(delta: float) -> void:
    if timer.is_stopped():
        timer.start(0.25)
        

func _on_timer_timeout() -> void:
    update_image()


func update_image() -> void:
    #pass
    render_target_update_mode = UPDATE_ONCE
    timer.start(0.25)


func add_continent(cont: Continent) -> TextureRect:
    var shader_mat := ShaderMaterial.new()
    shader_mat.shader = cont.get_shader()
    
    var rect := TextureRect.new()
    rect.texture = cont.texture
    rect.material = shader_mat
    rect.set_meta(&"continent", cont)
    cont_list.add_child(rect)
    rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    update_cont(cont_list.get_child_count()-1)
    return rect
    

func update_cont(entry: int) -> void:
    var rect :TextureRect= cont_list.get_child(entry)
    var shader_mat :ShaderMaterial= rect.material
    var cont :Continent= rect.get_meta(&"continent")
    shader_mat.shader = cont.get_shader()
    shader_mat.set_shader_parameter(&"rotation", cont.get_euler())
    shader_mat.set_shader_parameter(&"scale", cont.scale)
    shader_mat.set_shader_parameter(&"center_offset", cont.image_offset)
    shader_mat.set_shader_parameter(&"image_rotation", cont.image_rotation)
    shader_mat.set_shader_parameter(&"ratio", 
        cont.texture.get_size() / Vector2(size.y, size.y))
    update_image()


func _continent_order_changed(from: int, to: int) -> void:
    cont_list.move_child(cont_list.get_children()[from], to)


func _change_entry_visibility(entry: int, state: bool) -> void:
    cont_list.get_child(entry).visible = state


func _on_base_continent_changed(entry: int) -> void:
    update_cont(entry)


func _on_base_continent_added(index: int) -> void:
    add_continent(base.continents[index])


func _on_base_continent_removed(index: int) -> void:
    cont_list.remove_child(cont_list.get_child(index))
    update_image()


func _on_base_continent_selected(index: int) -> void:
    set_selected(index)


func _on_d_globe_render_mouse_exited() -> void:
    set_hover(-1)


func set_selected(index: int) -> void:
    set_highlight(index, 0.125)
    for i in cont_list.get_child_count():
        var rect :TextureRect= cont_list.get_child(i)
        var shader_mat :ShaderMaterial= rect.material
        if i == index:
            shader_mat.set_shader_parameter(&"selected", true)
        else:
            shader_mat.set_shader_parameter(&"selected", false)


func set_highlight(index: int, amount: float) -> void:
    for i in cont_list.get_child_count():
        var rect :TextureRect= cont_list.get_child(i)
        var shader_mat :ShaderMaterial= rect.material
        if i == index:
            shader_mat.set_shader_parameter(&"highlight", amount)
        else:
            shader_mat.set_shader_parameter(&"highlight", 0.0)

    

func set_hover(index: int) -> void:
    set_highlight(index, 0.25)
    update_image()
    
    #var rect :TextureRect= %HighlightViewport/Rect
    #if index == -1:
        #rect.hide()
        #return
        #
    #var rect_other :TextureRect= cont_list.get_child(index)
    #var shader_mat :ShaderMaterial= rect_other.material
    #rect.material = shader_mat
    #rect.modulate = Color.GREEN
    #rect.modulate.a = 0.25
    #rect.show()
