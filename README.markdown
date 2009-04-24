Gravity demo
============

Small iPhone and iPod touch application showning pool balls over a pool table
under the influence of gravity, using the accelerometers from the device to
know where the balls should fall.

Code Organization
=================

“Classes” directory contains the code for the application, and “Chipmuck”
contains the code for the Chipmuck physics library.

“Classes” directory
-------------------

- GRAppDelegate: Initialization code for the application.
- GRController: Initialization code for the objects and physics. Drawing code
  for the OpenGL view. Delegate for both GREAGLView and UIAccelerator.
- GREAGLView: Typical OpenGL view with delegate.
- GRSprite: Common code for all sprites.
- GRPoolTable: Builds the pool table static physics object. Optimization code
  for drawing the sprite on the device using DrawTex extension.
- GRPoolTable: Build a ball physics object.
- Texture2D: Loads images and turn them into OpenGL textures.

Work to do
==========

- Some kind of texture manager: right now each ball generates its own texture.
- Better organization for the physics integration (passing around the space
  and static body doesn't seems right).
- Implement the right physics: Chipmuck do not work for “over the table”
  physics.

Credits
=======

Author: Daniel Rodríguez Troitiño (drodrigueztroitino thAT yahoo thOT es).

Using Chipmunk <http://code.google.com/p/chipmunk-physics/> for the physics
simulation. Chipmuck 4.1.0 code is included.

Using Texture2D code provided by Apple in the old sample Lunar Lander.