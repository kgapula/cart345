// A class for a particle system

class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  float lifespan;

  Particle(PVector l) {
    // Make a vector to mimic constant acceleration
    acc = new PVector(0,0.05,0);
    vel = new PVector(random(-1,1),random(-1,0),0);
    vel.mult(2);
    pos = l.get();
    // give particles a lifespan
    lifespan = 255;
  }

  void run() {
    update();
    render();
  }

  // Method to update position
  void update() {
    vel.add(acc);
    pos.add(vel);
    lifespan -= 2.0;
  }

  // Method to display
  void render() {
    imageMode(CENTER);
    
    // set a random color
    float r = int(random(255));
    float g = int(random(255));
    float b = int(random(255));
    color c = color(r, g, b);
    
    // tint our image that color
    tint(c, lifespan);
    image(img, pos.x, pos.y);
  }
  
  // Check if the particle is still alive
  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com
