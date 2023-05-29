
class Extremo {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass = 10, dt = 0.25;
  PVector gravity;
  float Ec, Ep;
   
  // Arbitrary damping to simulate friction / drag
  float damping = 0.5;
 
  // For mouse interaction
  PVector dragOffset;
  boolean dragging = false;
 
  // Constructor
  Extremo(float x, float y) {
    location = new PVector(x,y);
    velocity = new PVector();
    acceleration = new PVector();
    dragOffset = new PVector();
    gravity = new PVector(0, 9.8);
  }
 
  void update() {
    applyForce(PVector.mult(gravity, mass));

    velocity = PVector.add(PVector.mult(acceleration, dt), velocity);
    location = PVector.add(PVector.mult(velocity, dt), location);
    acceleration = new PVector(0.0, 0.0);
  }
 
  // Newton's law: F = M * A
  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);
    acceleration.add(f);
  }
 
  // Draw
  void display() {
    stroke(0);
    strokeWeight(2);
    fill(175,120);
    if (dragging) {
      fill(50);
    }
  }

}
 
