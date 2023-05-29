// Problem description: //<>// //<>//
// Deformable object simulation
import peasy.*;

// Display control:

PeasyCam _camera;   // Mouse-driven 3D camera

// Simulation and time control:

float _timeStep;              // Simulation time-step (s)
int _lastTimeDraw = 0;        // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;         // Simulated time (s)
float _elapsedTime = 0.0;     // Elapsed (real) time (s)

// Output control:

boolean _writeToFile = false;
PrintWriter _output;

// System variables:

DeformableObject band1;              // Bandera 1
DeformableObject band2;              // Bandera 1
DeformableObject band3;              // Bandera 1
SpringLayout _springLayout;           // Current spring layout
PVector _airForce = new PVector();    // Air force from the inside of the deformable object
PVector _ballVel = new PVector();     // Ball velocity

// Main code:

void settings()
{
  size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
}

void setup()
{
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();

  float aspect = float(DISPLAY_SIZE_X)/float(DISPLAY_SIZE_Y);
  perspective((FOV*PI)/180, aspect, NEAR, FAR);
  _camera = new PeasyCam(this, 0);
  _camera.rotateX(QUARTER_PI);
  _camera.rotateZ(PI);
  _camera.setDistance(1000);

  _springLayout = SpringLayout.STRUCTURAL;
  initSimulation(_springLayout);
}

void stop()
{
  endSimulation();
}

void keyPressed()
{
  if (key == '1')
    restartSimulation(SpringLayout.STRUCTURAL);

  if (keyCode == RIGHT)
    _airForce.mult(1.05);

  if (keyCode == LEFT)
    _airForce.div(1.05);

  if (key == 'D' || key == 'd')
    DRAW_MODE = !DRAW_MODE;

  if (key == 'I' || key == 'i')
    initSimulation(_springLayout);
    
  if (key == 'W' || key == 'w')
    _applywind = !_applywind;
}

void initSimulation(SpringLayout springLayout)
{
  if (_writeToFile)
  {
    _output = createWriter(FILE_NAME);
    writeToFile("t, n, Tsim");
  }

  _simTime = 0.0;
  _timeStep = TS*TIME_ACCEL;
  _elapsedTime = 0.0;
  _airForce = viento;
  band1 = new DeformableObject(N_X, N_Y, N_Z, D_X, D_Y, D_Z, springLayout, OBJ_COLOR);
}

void restartSimulation(SpringLayout springLayout)
{
  _simTime = 0.0;
  _timeStep = TS*TIME_ACCEL;
  _elapsedTime = 0.0;
  _springLayout = springLayout;
  band1 = new DeformableObject(N_X, N_Y, N_Z, D_X, D_Y, D_Z, springLayout, OBJ_COLOR);
}

void endSimulation()
{
  if (_writeToFile)
  {
    _output.flush();
    _output.close();
  }
}

void draw()
{
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;

  //println("\nDraw step = " + _deltaTimeDraw + " s - " + 1.0/_deltaTimeDraw + " Hz");

  background(BACKGROUND_COLOR);
  drawStaticEnvironment();
  drawDynamicEnvironment();

  if (REAL_TIME)
  {
    float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
    float expectedIterations = expectedSimulatedTime/_timeStep;
    int iterations = 0;

    for (; iterations < floor(expectedIterations); iterations++)
      updateSimulation();

    if ((expectedIterations - iterations) > random(0.0, 1.0))
    {
      updateSimulation();
      iterations++;
    }

    //println("Expected Simulated Time: " + expectedSimulatedTime);
    //println("Expected Iterations: " + expectedIterations);
    //println("Iterations: " + iterations);
  } else
    updateSimulation();

  displayInfo();

  if (_writeToFile)
    writeToFile(_simTime + "," + band1.getNumNodes() + ", 0");
}

void drawStaticEnvironment()
{
  noStroke();
  fill(255, 0, 0);
  box(1000.0, 1.0, 1.0);

  fill(0, 255, 0);
  box(1.0, 1000.0, 1.0);

  fill(0, 0, 255);
  box(1.0, 1.0, 1000.0);

  fill(255, 255, 255);
  sphere(1.0);
}

void drawDynamicEnvironment()
{
  band1.render();
}

void updateSimulation()
{
  if(_applywind)
  {
    viento = new PVector(random(-5,-0.5),random(0,-0.5),random(1,6));
  }
  band1.update(_timeStep, _airForce);

  _simTime += _timeStep;
}

void writeToFile(String data)
{
  _output.println(data);
}

void displayInfo()
{
  pushMatrix();
  {
    camera();
    fill(0);
    textSize(20);

    text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.025, height*0.05);
    text("Elapsed time = " + _elapsedTime + " s", width*0.025, height*0.075);
    text("Simulated time = " + _simTime + " s ", width*0.025, height*0.1);
    text("Spring layout = " + _springLayout, width*0.025, height*0.125);
    text("Ball start velocity = " + _ballVel + " m/s", width*0.025, height*0.15);
    text("Air force = " + _airForce + " N", width*0.025, height*0.175);
  }
  popMatrix();
}
