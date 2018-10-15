// The mover class, which contains our moving bodies (text)

class Mover {

  // position, velocity, and acceleration 
  PVector position;
  PVector velocity;
  PVector acceleration;

  // Mass is tied to size
  float mass;

  Mover(float m, float x, float y) {
    mass = m;
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  // Newton's 2nd law: F = M * A
  // or A = F / M
  void applyForce(PVector force) {
    // Divide by mass 
    PVector f = PVector.div(force, mass);
    // Accumulate all forces in acceleration
    acceleration.add(f);
  }

  void update() {

    // Velocity changes according to acceleration
    velocity.add(acceleration);
    // position changes by velocity
    position.add(velocity);
    // We must clear acceleration each frame
    acceleration.mult(0);
  }

  // Draw Mover
  void display() {
    stroke(0);
    strokeWeight(2);
    
    fill(127, 200);
    
    if(inLiquid){
      fill(0, 255, 0);
    } 
    
    if(position.y < 100) {
      fill(0, 0);
    }
    
    //ellipse(position.x, position.y, mass*16, mass*16);
    textFont(stressful);
    text(worry, position.x, position.y);
  }

  // Bounce off bottom of window
  void checkEdges() {
    if (position.y < 0) {
     // velocity.y *= -0.9;  // A little dampening when hitting the bottom
      position.y = 0;
    }
  }
}

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com
