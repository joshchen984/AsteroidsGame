class Spaceship extends Floater
{   
    public Spaceship(color c){
      corners = 4;
      myCenterX = width/2;
      myCenterY = height/2;
      myXspeed = 0;
      myYspeed = 0;
      myPointDirection = 0;
      myColor = c;
      xCorners = new int[corners];
      yCorners = new int[corners];
      
      createCorners();
    }
    public double getX(){
      return myCenterX;
    }
    public double getY(){
      return myCenterY;
    }
    public void move(){
      super.move();
      float decay = 0.05;
      if (myXspeed > 0){
      myXspeed = Math.max(myXspeed - myXspeed * decay,0);
      }else{
        myXspeed = Math.min(myXspeed - myXspeed * decay,0);
      }
      
      if (myYspeed > 0){
      myYspeed = Math.max(myYspeed - myYspeed * decay,0);
      }else{
        myYspeed = Math.min(myYspeed - myYspeed * decay,0);
      }
    }
    public void hyperspace(){
      myXspeed = 0;
      myYspeed = 0;
      myPointDirection = (Math.random() * 360);
      myCenterX = Math.random() * width;
      myCenterY = Math.random() * height;
    }
    public void show(boolean accelerate){
      //translate the (x,y) center of the ship to the correct position
      translate((float)myCenterX, (float)myCenterY);
      //convert degrees to radians for rotate()     
      float dRadians = (float)(myPointDirection*(Math.PI/180));
      //rotate so that the polygon will be drawn in the correct direction
      rotate(dRadians);
      
      //creating boosters
      if (accelerate){
      stroke(255,0,0);
      fill(255,0,0);
      rect(-30,7,20,3);      
      rect(-30,0,20,3);      
      rect(-30,-7,20,3);      
      }
      
      fill(myColor);   
      stroke(myColor);    
      //draw the polygon
      beginShape();
      for (int nI = 0; nI < corners; nI++)
      {
        vertex(xCorners[nI], yCorners[nI]);
      }
      endShape(CLOSE);

      //"unrotate" and "untranslate" in reverse order
      rotate(-1*dRadians);
      translate(-1*(float)myCenterX, -1*(float)myCenterY);

    }
    private void createCorners(){
      xCorners[0] = 20;
      yCorners[0] = 0;
      xCorners[1] = -20;
      yCorners[1] = 15;
      xCorners[2] = -15;
      yCorners[2] = 0;
      xCorners[3] = -20;
      yCorners[3] = -15;

    }
    
    
}
