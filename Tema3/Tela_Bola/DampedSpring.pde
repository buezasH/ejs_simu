// Damped spring between two particles:
//
// Fp1 = Fe - Fd
// Fp2 = -Fe + Fd = -(Fe - Fd) = -Fp1
//
//    Fe = Ke·(l - l0)·eN
//    Fd = -Kd·eN·v
//
//    e = s2 - s1  : current elongation vector between the particles
//    l = |e|      : current length
//    eN = |e|/l   : current normalized elongation vector
//    v = dl/dt    : rate of change of length

public class DampedSpring
{
  Particle _p1;   // First particle attached to the spring
  Particle _p2;   // Second particle attached to the spring

  float _Ke;      // Elastic constant (N/m)
  float _Kd;      // Damping coefficient (kg/m)

  float _l0;      // Rest length (m)
  float _l;       // Current length (m)
  float _v;       // Current rate of change of length (m/s)

  PVector _e;     // Current elongation vector (m)
  PVector _eN;    // Current normalized elongation vector (no units)
  PVector _F;     // Force applied by the spring on particle 1 (the force on particle 2 is -_F) (N)
  
  boolean only_push;

  DampedSpring(Particle p1, Particle p2, float Ke, float Kd, boolean op)
  {
    _p1 = p1;
    _p2 = p2;

    _Ke = Ke;
    _Kd = Kd;

    _e = PVector.sub(_p2.getPosition(), _p1.getPosition());
    _eN = _e.copy();
    _eN.normalize();

    _l = _e.mag();
    _l0 = _l; 
    _v = 0.0;

    only_push = op;
    _F = new PVector(0.0, 0.0, 0.0);
  }

  Particle getParticle1()
  {
    return _p1;
  }
  
  Particle getParticle2()
  {
    return _p2;
  }
  
  void setRestLength(float l0)
  {
    _l0 = l0;
  }
  
  void update(float simStep)
  {
     float el_act;
     float p_l = _l; //l actual        
     
     _e = PVector.sub(_p2.getPosition(), _p1.getPosition()); //elongacion
     _l = _e.mag(); //nueva l
     
     if(only_push)
       el_act = _l - _ball.getRadius();
     else
       el_act = _l - _l0; 
    
     _eN = _e.copy();
     _eN.normalize(); 
     
     _v = (_l - p_l) / simStep; 
     
     //damping
     PVector aux_l = PVector.mult(_eN.copy(), _v); 
     PVector Fd = PVector.mult(aux_l, _Kd); 
     
     PVector Fe = PVector.mult(_eN, _Ke * el_act); 
     
     //Suma de fuerzas 
     if(!only_push ){
       _F = Fe.add(Fd);
       applyForces();
     }
     else if(el_act < _ball.getRadius())
     {
        _F = Fe.add(Fd);
       applyForces();
     }
     
     
    
  }

  void applyForces()
  { 
    _p1.addExternalForce(_F);
    _p2.addExternalForce(PVector.mult(_F, -1.0));
  }
}
