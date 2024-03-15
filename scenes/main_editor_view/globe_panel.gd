extends TextureRect

@onready var camera :Camera3D= %Camera3D
@onready var camera_viewport :Viewport= %GlobeMesh.get_viewport()
@onready var camera_raycast :RayCast3D= %Camera3D/RayCast3D

@onready var base :Node= get_tree().current_scene
#func _gui_input(event: InputEvent) -> void:
            
func get_closest_continent(max_distance :float) -> int:
    var point := camera_raycast.get_collision_point().normalized()
    point = %GlobeMesh.basis.inverse() * point
    var best_dist := max_distance
    var best : int = -1
    var i := 0
    const offset = TAU/2.0
    for continent in base.continents:
        var rad_lat := cos(continent.latitude*TAU)
        var cont_position := Vector3(
            sin(continent.longitude * TAU+offset) * rad_lat,
            sin(continent.latitude  * TAU),
            cos(continent.longitude * TAU+offset) * rad_lat
        )
        var new_dist := cont_position.angle_to(point)
        if new_dist < best_dist:
            best_dist = new_dist
            best = i
        i += 1
    return best
    


func _on_d_globe_render_gui_input(event: InputEvent) -> void:   
    if event.is_action("zoom_in") || event.is_action("zoom_out"):
        var value := Input.get_axis("zoom_out", "zoom_in")
        %Camera3D.fov += -value * %Camera3D.fov * 0.05
        
    if event is InputEventMouse:
        camera.get_viewport()
        camera_raycast.target_position = camera.project_local_ray_normal(\
            camera_viewport.get_mouse_position()) * 3.0
        camera_raycast.force_raycast_update()
        if camera_raycast.is_colliding():
            var cont := get_closest_continent(TAU/4.0)
            %TextureViewport.set_hover(cont)
            
            if event is InputEventMouseButton:
                var mouse_event :InputEventMouseButton= event; \
                if mouse_event.button_index == MOUSE_BUTTON_LEFT \
                && mouse_event.pressed:
                    base.continent_selected.emit(cont)
            
        else:
            %TextureViewport.set_hover(-1)

