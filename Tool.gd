extends Node
tool


func _ready():
    if Engine.editor_hint:
        $"../MapView1/OptionButton".select(0)
        $"../MapView2/OptionButton".select(1)
#        $"../MapView2/ScrollContainer/TextureRect".set_projection_mode(
#            $"../MapView1/OptionButton".selected, 
#            $"../MapView2/OptionButton".selected
#        )
#        material.shader = shader_pol_rec
#        [Proj.RECTANGULAR, Proj.POLAR]: 
        $"../MapView2/ScrollContainer/TextureRect".material.shader = load("res://from_pol_rec.shader")
        $"../MapView2/ScrollContainer/TextureRect".material.shader = load("res://from_rec_pol.shader")

    else:
        queue_free()
#        remove_and_skip(self)

#func _process(delta):
#    if Engine.editor_hint:
        
