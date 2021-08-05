# Globe Roller
A tool for fictional map makers and artists.
It's purpose is to reduce distortion in your globe's polar regions. This is done by transforming one projection into another using your gpu. Its very conveinient, and your polar ice caps will look better when mapped onto a sphere.

### Reccomended Workflow
Drag your image into GlobeRoller. It should be a 2x1 wide ratio. Set the top to rectangular and the bottom to polar. Then right click and choose save from the menu. Save the image. Now edit or draw your polar region to fit your intention. Once you are satisfied, put that image back into globe roller and reverse the projections (Set the top to polar and the bottom to rectangular). Save the result, and test it in a program like G-Plates! You're done!

## Map projections
### Rectangular / Equirectangular / Equidistant Cylindrical Projection
All lattitudes and longitudes are envenly spaced, with the north pole allong the top and the south pole allong the bottom.

### Azimuthal equidistant projection (polar in Globe Roller)
This is a radial projection centered on a point. In Globe Roller, this is split into the north and south hemisphere on the left and right respectively. They are aligned such that the prime meridian is horizontal and is connected between the two hemisphere circles.
