# Globe Roller
A tool for fictional map makers and artists.
The problem that inspired this project is something I think a lot of fantasy map makers struggle with. When you try to draw a contintent that will sit on or near the pole of your fantasy globe, you want to draw how it will look from the sky. Come time to measure distances to faraway places, you realize you need to somehow map your polar continent onto a rectangular map (if not to do trigonometry, to map it to a sphere in 3d sofware). This is difficult and can lead to frustrating comprimises as the artst gets to the end of their tolerance for trial and error. With this you can simply draw the continent how you want it to look and map it to the poles. Simple as.

### Reccomended Workflow
Drag your image into GlobeRoller. It can be any ratio. Click on where your image appears in the data list, and you will see an inspector panel pop up. Here you should then adjust the size of your new region to match how you envision it. Notice that there are two triplets of measures for moving your image around. The bottom one applies before your image is mapped to the desired projection, and the top set (lattitude and longitude and rotation) are applied after. This is in case you want to for instance, adjust the rotation center of your map, or you want the vertical to run lengthwise allong your rectangular map.

## Map projections
### Azimuthal (Azimuthal equidistant projection)
This is a radial projection centered on a point. All points are the same direction and distance from the center as they appear in the original image.

### Equirectangular
All lattitudes and longitudes are envenly spaced in a rectangular grid, with the north pole allong the top and the south pole allong the bottom. This is a good projection to use for long continents. This technically the same type of projection used internally to render the globe.

### Geodesic
This is a special projection I engineered to be able to map the edges of the map to geodesic arcs. Essentially, all straght lines are preserved, at the cost of severe distortion at the edges when the coverage approaches an entire hemisphere.

## Future plans
 - Undo buffer
 - More export projections besides equirect
 - More options for specific projections
 - More projections
 - Display options for the globe view
 - Atmospheric simulation? possibly using [Atlas](https://github.com/ecmwf/atlas)
