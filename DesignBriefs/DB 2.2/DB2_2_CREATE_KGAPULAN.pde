import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

/*
 Kyle Gapulan
 CART345
 Prof. J. Lewis
 Octiber 15 2018
 
 Design Brief 2.2
 Moving Material: CREATE
 
 How meanings change. How words transform. 
 How things mis-represent themselves or are fertile and mean many things all at once. 
 Mutability. Transformation. Miscomprehension. Mass-communication

 Create a motion graphics work that features digital typography. 
 It must be at least 30 seconds duration and include kinetic / motion typography. 
 In other words, make a short film / website / screen-based mutimedia work that includes text that has been digitally modified.
 */

// set up minim sound library
Minim minim;

// make variables to hold sound clips
AudioPlayer sparkle;
AudioPlayer falling;

// load Fonts
PFont stressful;
PFont light;

// used for background effects
Background background; 

// An array moving bodies, aka our text
Mover[] movers = new Mover[1];

// Liquid
Liquid liquid;

boolean inLiquid = false;
boolean makeText = false;

// A string to hold text input
String worry = "";

// A boolean that tracks whether the user has let go of their worry
boolean released = false;

// A boolean that tracks the position of the mover and makes colorful particles accordingly
boolean makeRain = false;

// Particle system for the "explosion"
ParticleSystem ps;
// A PImage to hold the texture for the particles
PImage img; 

// A PImage to hold the rocket image
PImage rocket;

//Text particles (additional explosion particles)
int MAX_PARTICLE;
TextParticle[] textParticle;

// A PGraphics element to shape our text particles
PGraphics textShape;

//arrays for background tiles
//X and Y positions
int[] bgX = new int[50];
int[] bgY = new int[50];

void setup() {
  size(700, 700, P2D);
  
  //setup minim library
  minim = new Minim(this);
  sparkle = minim.loadFile("Sparkle.wav");
  falling = minim.loadFile("Falling.wav");
  
  //load fonts
  stressful = createFont("Dirty Headline.ttf", 18);
  light = createFont("Lato-Light.ttf", 16);
  
  
  //Initialize all elements of the XY arrays to zero
  for (int i = 0; i < bgX.length; i++) {
    bgX[i] = 0;
    bgY[i] = 0;
  }
  
  reset();
  // Create liquid object as well as any objects that load as the sketch starts
  //liquid = new Liquid(0, height/2, width, 10, 0.1);
  
  liquid = new Liquid(0, 100, width, 20, 0.05);
  
  // link our files to the variables we created above
  img = loadImage("texture.png");
  rocket = loadImage("rocket.png");
  
  // make a particle system to hold and display our firework-esque particles
  ps = new ParticleSystem(0, new PVector(width/2, 100));

  // set variables for the additional text particles
  // limit the number of particles to the size of the canvas
  MAX_PARTICLE = width * height;
  textParticle = new TextParticle[MAX_PARTICLE];
  for (int i = 0; i < MAX_PARTICLE; i++) {
    textParticle[i] = new TextParticle();
  }
}

void draw() {
  background(0);
  
  background = new Background();
  background.display();
  
  
  // Draw water, aka the "trigger" zone for particles to fall
  liquid.display();

  for (int i = 0; i < movers.length; i++) {

    // Check the position of the text
    if (liquid.contains(movers[i])) {
      inLiquid = true;
      // Calculate drag force
      PVector dragForce = liquid.drag(movers[i]);
      // Apply drag force to Mover
      movers[i].applyForce(dragForce);
      
      sparkle.play();
      ps.run();
      ps.addParticle();
      
      //if(movers[i].y > liquid.y) {
      //  makeRain = true;
      //}
      
      //if(makeRain){
      ////MAKE THIS RUN ONLY WHEN TEXT IS UP
      //ps.run();
      //for (int j = 0; j < 10; j++) {
      //  ps.addParticle();
      //}
      //}

      //generateParticle();
    } else {
      inLiquid = false;
    }

    if (inLiquid) {
      makeText = true;
      if (makeText) {
        generateParticle();
        makeText = false;
      }
    }

    // Gravity is scaled by mass here!
    PVector gravity = new PVector(0, -0.1*movers[i].mass);
    // Apply gravity
    if (released) {
      movers[i].applyForce(gravity);
      falling.play();
    }

    // Update and display
    movers[i].update();
    movers[i].display();
    movers[i].checkEdges();
  }

  loadPixels();
  for (int i = 0; i < MAX_PARTICLE; i++) {
    if (textParticle[i].textPartAlive) {
      textParticle[i].move();
      if (textParticle[i].textPartAlive && textParticle[i].getIndex() < width * height) {
        int index = textParticle[i].getIndex();
        // map the color 
        pixels[index] = textParticle[i].pixelColor;
      }
    }
  }
  updatePixels();
  
  // the following elements display instructions on how to use the sketch
  textAlign(LEFT);
  fill(255);
  
  textFont(light);
  text("Click mouse to reset", 10, height-30);
  text("Press Enter to let go of worries", 10, height-50);
  text("What's on your mind?"+ " : " + worry, 10, height-70);
  
  //draw the rocket
  //image(rocket, width/2-100, height-120, 100, 100);
}


void mousePressed() {
  reset();
  sparkle.pause();
  sparkle.rewind();
  falling.pause();
  falling.rewind();
}

void keyPressed() {
  worry = worry + key;

  if (key==ENTER||key==RETURN) {
    released = true;
  }
}

// Restart all the Mover objects randomly
void reset() {
  for (int i = 0; i < movers.length; i++) {
    //movers[i] = new Mover(random(0.5, 3), 40+i*70, height-10);
    textAlign(CENTER);
    movers[i] = new Mover(random(0.5, 3), width/2, height-30);
  }
  worry = "";
  released = false;

  // liquid.resetLiquid();
}

void generateParticle() {
  //  Draw the shape on the canvas
  textShape = createGraphics(width, height, P2D);
  textShape.beginDraw();
  textShape.background(0);
  textShape.textFont(light);
  textShape.textSize(200);
  // Link the worry variable to the PGraphics elemnts
  textShape.text(worry, random(width / 3), random(height * 1.5));
  textShape.endDraw();

  //  Create the particles
  textShape.loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      // if each pixel is not yet black (or "dead")
      if (textShape.pixels[y * width + x] != color(0, 0, 0)) {
        textParticle[y * width + x].textPartAlive = true;
        // display it
        textParticle[y * width + x].pixelColor = textShape.pixels[y * width + x];
        // and give it a position
        textParticle[y * width + x].textPosition.set(x, y, 0);
      }
    }
  }
}

/*References:
The Nature of Code textbook
http://natureofcode.com/book/introduction/
https://natureofcode.com/book/chapter-4-particle-systems/

Processing reference & tutorials
https://processing.org/tutorials/video/
https://processing.org/examples/simpleparticlesystem.html
https://processing.org/reference/textFont_.html

Graphics:
Rocket by Ink The Moon from the Noun Project
*/
