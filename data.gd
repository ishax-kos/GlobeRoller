extends Object
class_name Data

#enum Proj {
    #ortho,
    #azimuth    
#}


const data :Array[Dictionary]= [
    {
        name = &"Equidistant cylindrical projection",
        description = \
            "Lattitudes and longitudes are evenly spaced "\
            +"over a square grid.",
        shader = preload("res://shaders/base.gdshader")
    },
    {
        name = &"Azimuthal equidistant projection",
        description = \
            "All points are arranged according to their "\
            +"angle distance from the nearest pole.",
        shader = preload("res://shaders/azimuthal_eq.gdshader")
    },
]
