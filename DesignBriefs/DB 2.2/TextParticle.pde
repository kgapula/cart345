class TextParticle{
  // track the lifespan of a text particle with a boolean
  boolean textPartAlive = false;
  // give each particle a position and velocity 
  PVector textPosition = new PVector();
  PVector textVelocity = new PVector();
  // give each pixel a color
  color pixelColor;
  
  TextParticle(){
    // randomize the velocity of pixels for a more interesting effect, moving horizontally
    textVelocity.set(random(5) + 0.1, 0, 0);
  }
  
  void move(){
    textPosition.add(textVelocity);
    // "Kill" each pixel if it travels off screen
    if(textPosition.x > width){
      textPartAlive = false;
    }
    if(textPosition.y > width){
      textPartAlive = false;
    }
    
    // slowly lower the RGB values to gradually fade to black
    float r = red(pixelColor) * 0.98;
    float g = green(pixelColor) * 0.98;
    float b = blue(pixelColor) * 0.98;
    
    pixelColor = color(r, g, b);
    if(pixelColor == color(0, 0, 0)){
      
      // when a particle is black, it is no longer "alive"
      textPartAlive = false;
    }
  }
  
  int getIndex(){
    // check the current position of each pixel
    return int(textPosition.y * width + textPosition.x);
  }
}

// Reference: p5info.com, OpenProcessing.org
