// Problem description:
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

HeightMap map;
PImage image;
PImage textureImage;

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

  initSimulation();
}

void stop()
{
  endSimulation();
}

void keyPressed()
{
  float dx = random (3.0) - 1;
  float dz = random (3.0) - 1;

  //Cambio de tipo de onda
  if (key == 'd' || key == 'D')
    map.addWave(true,new DirectionalWave(amplitude, wavelength, speed, new PVector(dx, 0, dz)));
    
  if (key == 'r' || key == 'R')  
    map.addWave(true,new RadialWave(amplitude, wavelength, speed, new PVector(0, 0, 0)));
    
  if (key == 'g' || key == 'G')
    map.addWave(true,new GerstnerWave(amplitude, wavelength, speed, new PVector(dx, 0, dz)));
  
  if (key == 'c' || key == 'C')
    _viewmode = !_viewmode;
    
  if(keyCode == UP)
    map.adjustValuesWave(5,0,0);
    
  if(keyCode == DOWN)
    map.adjustValuesWave(-5,0,0);
    
  if(keyCode == RIGHT)
    map.adjustValuesWave(0,5,0);
    
  if(keyCode == LEFT)
    map.adjustValuesWave(0,-5,0);
  
  if(key == 'v')
    map.adjustValuesWave(0,0,5);
  
  if(key == 'f')
    map.adjustValuesWave(0,0,-5);
    
}
  
void initSimulation()
{
  image = loadImage("text.jpg");
  textureImage = loadImage("mosaico.jpg");
  _simTime = 0.0;
  _timeStep = TS*TIME_ACCEL;
  _elapsedTime = 0.0;
  map = new HeightMap(_MAP_SIZE, _MAP_CELL_SIZE);
  map.run();
}

void restartSimulation()
{
  _simTime = 0.0;
  _timeStep = TS*TIME_ACCEL;
  _elapsedTime = 0.0;
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
}

void drawStaticEnvironment() {
  noStroke();
  
  // Dibujar la cara trasera del cubo
  beginShape();
  textureMode(NORMAL);
  texture(textureImage);
  vertex(-wallSize, -wallSize/2, wallSize, 0, 0);
  vertex(wallSize, -wallSize/2, wallSize, 1, 0);
  vertex(wallSize, wallSize, wallSize, 1, 1);
  vertex(-wallSize, wallSize, wallSize, 0, 1);
  endShape();
  
  //Dibujar cara lateral derecha
  beginShape();
  texture(textureImage);
  vertex(wallSize, -wallSize/2, wallSize, 0, 0);
  vertex(wallSize, -wallSize/2, -wallSize, 1, 0);
  vertex(wallSize, wallSize, -wallSize, 1, 1);
  vertex(wallSize, wallSize, wallSize, 0, 1);
  endShape();
  
  //Dibujar cara lateral izquierda
  beginShape();
  texture(textureImage);
  vertex(-wallSize, -wallSize/2, wallSize, 0, 0);
  vertex(-wallSize, -wallSize/2, -wallSize, 1, 0);
  vertex(-wallSize, wallSize, -wallSize, 1, 1);
  vertex(-wallSize, wallSize, wallSize, 0, 1);
  endShape();
  
  //Dibujar cara inferior
  beginShape();
  texture(textureImage);
  vertex(-wallSize, wallSize, wallSize, 0, 0);
  vertex(wallSize, wallSize, wallSize, 1, 0);
  vertex(wallSize, wallSize, -wallSize, 1, 1);
  vertex(-wallSize, wallSize, -wallSize, 0, 1);
  endShape();
  
  //Dibujar cara transparente frontal
  beginShape();
  fill(135, 206, 255, 200);  // Color azul claro y transparente
  vertex(-wallSize, 0, -wallSize);
  vertex(wallSize, 0, -wallSize);
  vertex(wallSize, wallSize, -wallSize);
  vertex(-wallSize, wallSize, -wallSize);
  endShape();
}

void drawDynamicEnvironment()
{
}

void updateSimulation()
{
  map.run();

  if (_viewmode)
    map.presentWired();
  else
  map.present();
  _simTime += _timeStep;
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
  }
  popMatrix();
}
