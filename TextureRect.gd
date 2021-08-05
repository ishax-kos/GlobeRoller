extends TextureRect
class_name MapRect

enum Proj {
    RECTANGULAR,
    POLAR    
}

const shader_rec_pol := preload("res://from_rec_pol.shader")
const shader_pol_rec := preload("res://from_pol_rec.shader")
const shader_base := preload("res://base.shader")


func _ready():
    material = ShaderMaterial.new()
    material.shader = shader_base


func set_projection_mode(mode_from, mode_to):
    match ([mode_from, mode_to]):
        [Proj.POLAR, Proj.RECTANGULAR]: 
            material.shader = shader_pol_rec
        [Proj.RECTANGULAR, Proj.POLAR]: 
            material.shader = shader_rec_pol
        _: if mode_from == mode_to:
            material.shader = shader_base



#func _on_MapView_resized():
#    pass
#    rect_scale = get_parent().rect_size / rect_min_size
#    update()

