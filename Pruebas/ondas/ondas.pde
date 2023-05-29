import peasy.*;

final int _MAP_SIZE = 150;
final float _MAP_CELL_SIZE = 10f;


float amplitude = random (2f) + 8f;
float wavelength = amplitude* (30 + random(2f));
float speed = wavelength/(1+random(3f));

boolean _viewmode = true;
boolean _clear = false;

PeasyCam camera;

HeightMap map;
PImage img;

public void settings()
{
  System.setProperty("jogl.disable.openglcore", "true");
  size (900, 600, P3D);
  
}

void setup()
{

  //img = loadImage("textura.jpg");
  camera = new PeasyCam(this, 100);
  camera.setMinimumDistance(50);
  camera.setMaximumDistance(3000);
  camera.setDistance(2300);
  camera.rotateX(0.1);
  
  map = new HeightMap(_MAP_SIZE, _MAP_CELL_SIZE);

}

void draw()
{
  background(255);
  map.run();
  
  if(_viewmode) 
    map.presentWired();
  else 
    map.present();
  
  presentAxis();
  drawInteractiveInfo();
  
  if(_clear)
  {
    map.waves.clear();
    map.waveArray = new Wave[0];
    amplitude = random (2f) + 8f;
    wavelength = amplitude* (30 + random(2f));
    speed = wavelength/(1+random(3f));
    _clear = false;
  }
  
}

void drawInteractiveInfo()
{
  float textSize = 120;
  float offsetX = -500;
  float offsetY = -1500;
  float offsetZ = -1500;
  
  int i = 0;
  noStroke();
  textSize(textSize);
  fill(0xff000000);
  text ("s: Onda sinusoidal", offsetX + offsetY, offsetY + textSize* (++i), offsetZ);
  text ("w: Onda radial", offsetX + offsetY, offsetY + textSize* (++i), offsetZ);
  text ("g: Onda de Gerstner", offsetX + offsetY, offsetY + textSize* (++i), offsetZ);
  text ("t: Textura o malla", offsetX + offsetY, offsetY + textSize* (++i), offsetZ);
  text ("r: Reset", offsetX + offsetY, offsetY + textSize* (++i), offsetZ);
  text ("l: aumentar 'wavelength' de la siguiente onda", offsetX + offsetY, offsetY + textSize* (++i), offsetZ);
  text ("o: disminuir 'wavelength' de la siguiente onda", offsetX + offsetY, offsetY + textSize* (++i), offsetZ);
  text ("v: aumentar 'velocidad' de la siguiente onda", offsetX + offsetY, offsetY + textSize* (++i), offsetZ);
  text ("b: disminuir 'velocidad' de la siguiente onda", offsetX + offsetY, offsetY + textSize* (++i), offsetZ);
  text ("tecla 'up': aumentar amplitud de la siguiente onda", offsetX +offsetY, offsetY + textSize* (++i), offsetZ);
  text ("tecla 'down': disminuir amplitud de la siguiente onda", offsetX +offsetY, offsetY + textSize* (++i), offsetZ);
  
  i = 0;
  text ("Valor de siguiente amplitud: " + amplitude, offsetX -offsetY, offsetY + textSize* (++i), offsetZ);
  text ("Valor de siguente 'wavelength': " + wavelength , offsetX -offsetY, offsetY + textSize* (++i), offsetZ);
  text ("Valor de siguente velocidad: " + speed, offsetX -offsetY, offsetY + textSize* (++i), offsetZ);
  
  
}

void keyPressed()
{
  float dx = random (2f) - 1;
  float dz = random (2f) - 1;

  //Cambio de tipo de onda
  if (key == 's' || key == 'S')
  {
    map.addWave(new WaveDirectional(amplitude, new PVector(dx, 0, dz), wavelength, speed));
  }
  if (key == 'w' || key == 'W')
  {
    map.addWave(new WaveRadial(amplitude, new PVector(dx*(_MAP_SIZE * _MAP_CELL_SIZE/2f), 0, dz*(_MAP_SIZE * _MAP_CELL_SIZE/2f)), wavelength, speed));
  }
  if (key == 'g' || key == 'G')
  {
    map.addWave(new WaveGerstner(amplitude, new PVector(dx, 0, dz), wavelength, speed));
  }
  
  //Cambio de modo de visualización
  if (key == 't' || key == 't')
  {
    _viewmode = !_viewmode;
  }
  
  //Resetear la simulación
  if (key == 'r' || key == 'r')
  {
    _clear = true;
  }
  
  //Cambio de parámetros de las ondas
  if (keyCode == UP )
  {
    amplitude = amplitude + 5f;
  }
  if (keyCode == DOWN )
  {
    amplitude = amplitude - 5f;
  }
  if (key == 'l' || key == 'L')
  {
    wavelength = wavelength + 5f;
  }
  if (key == 'o' || key == 'O')
  {
    wavelength = wavelength - 5f;
  }
  if (key == 'v' || key == 'V')
  {
    speed = speed + 10f;
  }
  if (key == 'b' || key == 'B')
  {
    speed = speed - 10f;
  }
  
}

void presentAxis()
{
  stroke(255, 0, 0);
  line(0, 0, 0, 0, -200, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 200, 0, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 200);
}
