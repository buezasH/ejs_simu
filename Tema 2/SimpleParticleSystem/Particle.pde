// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float m;
  final PVector G = new PVector(0.0,9.8);

  Particle(PVector l) {
    acceleration = new PVector(0.05, 0);
    velocity = new PVector(1, random(-1, 1));
    position = l.copy();
    lifespan = 255.0;
    m = 0.1;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
