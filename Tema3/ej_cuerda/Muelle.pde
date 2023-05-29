class Muelle {
 
  // Location
  PVector anchor;
 
  // Rest length and spring constant
  float len;
  float k = 25, Epe;
   
  // ElongaciÃ³n
  float x = 0;
   
  // Fuerzas
  PVector Fa = new PVector(0.0, 0.0);
  PVector Fb = new PVector(0.0, 0.0);
   
  Extremo a;
  Extremo b;
 
  // Constructor
  Muelle(Extremo a_, Extremo b_, int l) {
    a = a_;
    b = b_;
    len = l;
  }

  void update() {
    anchor = PVector.sub(b.location, a.location);
    x = anchor.mag() - len;
    anchor.normalize();
    Epe = -k * x;
    Fa = PVector.mult(anchor, -Epe);
    Fb = PVector.mult(anchor, Epe);
     
    // Amortiguacion
    Fa = PVector.sub(Fa, PVector.mult(a.velocity, a.damping));
    Fb = PVector.sub(Fb, PVector.mult(b.velocity, b.damping));
     
    a.applyForce(Fa);
    b.applyForce(Fb);
  }
 
 
  void display() {
    strokeWeight(2);
    stroke(0);
    line(a.location.x, a.location.y, b.location.x, b.location.y);
  }
}
