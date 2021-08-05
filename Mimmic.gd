extends TextureRect
tool

func _process(delta):
    var f := File.new()
    f.open("res://pol_to_rect.material", _File.READ)
    var m : ShaderMaterial = material
    m.shader.code = f.get_as_text()
    
