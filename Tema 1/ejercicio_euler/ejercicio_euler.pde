// Problema 1 - Tiro arabólico :  //<>//
// Plantilla basica para problemas de simulacion
// 3 pasos: 
//   a) Definir la funcion a(s(t), v(t)) en base a las fuerzas del problema y las condiciones iniciales del escenario
//   b) Definir una funcion para el integrador a emplear (Euler Explicito)
//   c) Simular: Integrar numericamente la aceleracion y la velocidad de la particula a dt's. (y pintar)

// Condiciones o parametros del problema:
final float   M  = 10.0;   // Particle mass (kg)
final float   Gc = 9.8;   // Gravity constant (m/(s*s))
final PVector G  = new PVector(0.0, -Gc);   // Acceleration due to gravity (m/(s*s))
float         K  = 0.2;     // Coefieciente de rozamiento
final PVector S0 = new PVector(10.0, 10.0);   // Particle's start position (pixels)

PVector _s  = new PVector();   // Position of the particle (pixels)
PVector _v  = new PVector();   // Velocity of the particle (pixels/s)
PVector _a  = new PVector();   // Accleration of the particle (pixels/(s*s))
PVector _v0 = new PVector();
PVector v_a = new PVector();
PVector s_a = new PVector();   // Position of the particle (pixels)

/////////////////////////////////////////////////////////////////////
// Parameters of the numerical integration:
float         SIM_STEP = .02;   // dt = Simulation time-step (s)
float         _simTime;
////////////////////////////////////////////////////////////////////////////77

// Ley de Newton: 
//      a(s(t), v(t)) = [Froz(v(t)) + Fpeso ]/m
//      Froz = -k·v(t)
//      Fpeso = mg; siendo g(0, -9.8) m/s²
//      
// Ejemplo de fuerzas para el tiro parabolico.
PVector calculateAcceleration(PVector s, PVector v)
{
  PVector Froz = PVector.mult(v, -K);
  PVector FPeso = PVector.mult(G,M);
  PVector SumF =new PVector(Froz.x, Froz.y);
  SumF.add(FPeso);
  
  PVector a = SumF.div(M);
  
  return a;
}

void settings()
{
    size(600, 600);
}

void setup()
{
  _v0.set(28.0, 80);
  _s = S0.copy();
  _v.set(_v0.x, _v0.y);
  _a.set(0.0, 0.0);
  _simTime = 0;
}

void draw()
{
  background(255);
 
  drawScene();
  updateSimulation();
  
  if(_s.y < 0){
    println(_s);
    exit();
  }
}

void drawScene()
{
  translate(0, height);
  strokeWeight(3);
  noFill();
  circle(_s.x, -_s.y, 60);
  
  strokeWeight(1);
  fill(200,0,0);
  circle(s_a.x, -s_a.y, 60/5);
}


void updateSimulation()
{
  updateSimulationExplicitEuler();
  
  _simTime += SIM_STEP;
  
  // Solucion analitica la posicion: doble integracion 
  s_a.x = S0.x + (M*_v0.x/K)*(1-exp((-K/M)*_simTime));
  s_a.y = S0.y + (M/K)*((M*Gc/K) + _v0.y)*(1-exp((-K/M)*_simTime)) - (M*Gc*_simTime)/K;
}

void updateSimulationExplicitEuler()
{
  PVector acel = calculateAcceleration(_s, _v);
  
  _s.add(PVector.mult(_v, SIM_STEP));
  _v.add(PVector.mult(acel, SIM_STEP));
}

void updateSimulationSimplecticEuler()
{
   _a =  calculateAcceleration(_s, _v);
   _s.add(PVector.mult(_a, SIM_STEP));
   _v.add(PVector.mult(_v, SIM_STEP));
}

void updateSimulationHeun()
{
  //Aceleracion en primer vector 
   _a =  calculateAcceleration(_s, _v);
   PVector s2 = PVector.add(_s, PVector.mult(_v,SIM_STEP));
   PVector v2 = PVector.add(_a, PVector.mult(_a,SIM_STEP));
   PVector a2 = calculateAcceleration(s2,v2);
   
  //Calculo velocidad media para heun
   PVector vheun = PVector.mult(PVector.add(_v,v2),0.5);
   _s.add(PVector.mult(vheun,SIM_STEP));
    
   PVector aheun = PVector.mult(PVector.add(_a,a2),0.5);
   _v.add(PVector.mult(aheun,SIM_STEP));
}

void updateSimulationRK2() {
  PVector k1v = PVector.mult(calculateAcceleration(_s, _v), SIM_STEP);
  PVector k1s = PVector.mult(_v, SIM_STEP);
  
  PVector s2 = PVector.add(_s, PVector.mult(k1s, 0.5));
  PVector v2 = PVector.add(_v, PVector.mult(k1v, 0.5));
  
  PVector k2v = PVector.mult(calculateAcceleration(s2, v2), SIM_STEP);
  PVector k2s = PVector.mult(PVector.add(_v, PVector.mult(k1v, 0.5)), SIM_STEP);
  
  _s.add(k2s);
  _v.add(k2v);
}




void keyPressed()
{
  if (key == 'r' || key == 'R')
  {
    setup();
  }
 
}
