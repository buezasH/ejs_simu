// Definitions:

// Spring Layout
enum SpringLayout
{
  STRUCTURAL,
    SHEAR,
    BEND,
    STRUCTURAL_AND_SHEAR,
    STRUCTURAL_AND_BEND,
    SHEAR_AND_BEND,
    STRUCTURAL_AND_SHEAR_AND_BEND
}

// Simulation values:

final boolean REAL_TIME = true;   // To make the simulation run in real-time or not
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time


// Display and output parameters:

boolean DRAW_MODE = false;                            // True for wireframe
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final float FOV = 60;                                 // Field of view (º)
final float NEAR = 0.01;                              // Camera near distance (m)
final float FAR = 10000.0;                            // Camera far distance (m)
final color OBJ_COLOR = color(250, 240, 190);         // Object color (RGB)
final color BALL_COLOR = color(225, 127, 80);         // Ball color (RGB)
final color BACKGROUND_COLOR = color(190, 1800, 210); // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables

// Parameters of the problem:

final float TS = 0.001;     // Initial simulation time step (s)
final float G = 9.81;       // Acceleration due to gravity (m/(s·s))
final float M = 0.1;

final int N_X = 15;         // Number of nodes of the object in the X direction
final int N_Y = 15;         // Number of nodes of the object in the Y direction
final int N_Z = 1;          // Number of nodes of the object in the Z direction

final float D_X = 3.0;     // Separation of the object's nodes in the X direction (m)
final float D_Y = 3.0;     // Separation of the object's nodes in the Y direction (m)
final float D_Z = 3.0;     // Separation of the object's nodes in the Z direction (m)

final float KE = 100.0;
final float KE_z = 100.0;
final float KD = 15;
final float KD_z = 15.0;

final PVector v_BALL = new PVector(0, 0, 0);
final float m_BALL = 2.5;
final float r_BALL = 8;
final float h_BALL = -10;
final PVector s_BALL = new PVector((N_X * D_X) / 3, (N_Y * D_Y) / 2, h_BALL);
final color color_BALL = color(255, 0, 0);

final PVector viento = new PVector(0, 0, 0);
boolean _applywind = false;
