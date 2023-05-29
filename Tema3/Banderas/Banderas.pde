//Simulación de banderas con interacción en gravedad y viento

//Cámara 3D
import peasy.*;
PeasyCam cam;

//Generaremos 3 banderas con diferentes estructuras
Malla m1, m2, m3;

//Tipos de estructura
final int STRUCTURED = 1;
final int BEND = 2;
final int SHEAR = 3;

//Tamaño de la malla
int puntosX;
int puntosY;

//Simulación
float dt = 0.1;
PVector g = new PVector (0,0,0); //gravedad
PVector viento = new PVector (0,0,0); //viento
boolean vientoActivo = false;
boolean gravedadActivo = false;


void setup()
{
  size (900, 600, P3D);
  smooth();
  
  //Cámara:
  cam = new PeasyCam(this, 500, 0, 0, 600);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(1000);
  
  //Las mallas son rectangulares
  puntosX = 50;
  puntosY = 30;
  
  //Creación de las 3 banderas
  m1 = new Malla (STRUCTURED, puntosX, puntosY);
  m2 = new Malla (BEND, puntosX, puntosY);
  m3 = new Malla (SHEAR, puntosX, puntosY);
  
}

void draw()
{
  background(255);
  translate(150, -100, 0);
  
  //Draw datos
  fill (0);
  
  //VIENTO
  if (vientoActivo)
  {
    viento.x = 0.5 - random(10, 40) * 0.1;
    viento.y = 0.1 - random(0, 0.2);
    viento.z = 0.5 + random(10, 60) * 0.1;

  }
  else
  {
    viento.x = 0; 
    viento.y = 0;
    viento.z = 0;
  }
  
  //GRAVEDAD
  if (gravedadActivo)
  {
    g.y = 4.9; //Reducimos el valor de la gravedad para que las banderas no caigan drásticamente 
  }
  else
  {
    g.y = 0;
  }
  
  //BANDERA STRUCTURED
  m1.update();
  
  color c = color(255,0,0);
  m1.display(c);
  
  text("STRUCTURED", 10, 270, 0);
  
  line(0, 0, 0, 255);
  
  
  
  
  //BANDERA BEND
  m2.update();
  
  pushMatrix();
  translate(255,0,0);
  
  color c2 = color(0,255,0);
  m2.display(c2);
  
  text("BEND", 10, 270, 0);
  
  line(0, 0, 0, 255);
  
  popMatrix();
  
  
  
  
  //BANDERA SHEAR
  m3.update();
  
  pushMatrix();
  
  translate(500,0,0);
  
  color c3 = color(0,0,255);
  m3.display(c3);
  fill(0);
  
  text("SHEAR", 10, 270, 0);
  
  line(0, 0, 0, 255);
  
  popMatrix();
  
}

//Interfaz de usuario
void keyPressed()
{
  if (key == 'v' || key == 'V')
  {
    if (vientoActivo == false)
    {
      vientoActivo = true;
    }
    else if (vientoActivo == true)
    {
      vientoActivo = false;
    }
  }
  
  if (key == 'g' || key == 'G')
  {
    if (gravedadActivo == false)
    {
      gravedadActivo = true;
    }
    else if (gravedadActivo == true)
    {
      gravedadActivo = false;
    }
  }
}
