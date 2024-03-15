extends Resource
class_name Continent

enum Projection_type {
    Azimuthal = 0,
    Equirectangular,
    Geodesic,
}
const projection_names :Array[String]= [
    "Azimuthal",
    "Equirectangular",
    "Geodesic"
]

const projection_shaders :Array[Shader]= [
    preload("res://shaders/continent_azimuth.gdshader"),
    preload("res://shaders/continent_equirect.gdshader"),
    preload("res://shaders/continent_geodesic.gdshader"),
]
const projection_icons :Array[Texture2D]= [
    preload("res://icons/azimuth.png"),
    preload("res://icons/equirect.png"),
    preload("res://icons/geodesic.png"),
]

@export var projection :Projection_type
@export var texture :Texture2D
@export var name :String
@export_range(-0.5, 0.5) var latitude : float
@export_range(-0.5, 0.5) var longitude : float
@export_range(-0.5, 0.5) var rotation : float

#var texture_path :String

@export var image_offset : Vector2
@export_range(0, TAU) var image_rotation : float
@export_range(0, 10) var scale :float = 1.0

func get_basis() -> Basis:
    return Basis.from_euler(get_euler())

func get_euler() -> Vector3:
    return Vector3(latitude, longitude, rotation)

func get_shader() -> Shader:
    return projection_shaders[projection]


static func from_image(path: String) -> Continent:
    var image := Image.load_from_file(path)
    if !image || image.is_empty():
        return null
    var texture = ImageTexture.create_from_image(image)
    var file_name := path\
        .get_file().rsplit(".", true, 1)[0]
    
    var cont := Continent.new()
    cont.name = file_name
    #cont.texture_path = 
    cont.texture = texture
    cont.scale = 1.0
    return cont

#func _init():
    
#func new_continent(
    #
#) -> Continent:
