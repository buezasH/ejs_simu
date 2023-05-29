// Definitions:

// Simulation values:

final boolean REAL_TIME = false;   // To make the simulation run in real-time or not
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time


// Display and output parameters:

boolean DRAW_MODE = false;                            // True for wireframe
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final float FOV = 60;                                 // Field of view (º)
final float NEAR = 0.01;                              // Camera near distance (m)
final float FAR = 10000.0;                            // Camera far distance (m)
final color BACKGROUND_COLOR = color(190, 1800, 210); // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables

// Parameters of the problem:

final float TS = 0.001;     // Initial simulation time step (s)
// Map
final int _MAP_SIZE = 150;
final float _MAP_CELL_SIZE = 10.0;
final float wallSize = (_MAP_SIZE * _MAP_CELL_SIZE)/2;


float amplitude = 12;
float wavelength = amplitude* (35);
float speed = wavelength/(15.0);

boolean _viewmode = false;
boolean _clear = false;
