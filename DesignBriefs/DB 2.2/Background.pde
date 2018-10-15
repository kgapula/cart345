// A class for the background tiles

class Background {
  void display() {
    //push all array elements one spot down, stopping at the last element
    for (int i = 0; i < bgX.length-1; i++) {
      bgX[i] = bgX[i+1];
      bgY[i] = bgY[i+1];
    }
    
    //give the tiles new XY coordinates, limiting them to the borders of the canvas 
    bgX[bgX.length-1] = int(random(width));
    bgY[bgY.length-1] = int(random(height));
    
    //draw the tiles
    for (int i = 0; i < bgX.length; i++) {
      pushStyle();
      noStroke();
      //give a color according to i
      //low opacity
      fill((255-i*5), 40);
      
      if(inLiquid){
        fill(random(255), random(255), random(255));
      }
      
      //draw the shape
      rect(bgX[i], bgY[i], i, i);
      popStyle(); // push and pop styles to limit the changes only to this section of code
    }
  }
}
