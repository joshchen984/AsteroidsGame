class Asteroid extends Floater{
    private int rotationSpeed;
    private int size, start;
    public Asteroid(color c){
        start = (int)(Math.random() * 4);
        corners = 5;
        myPointDirection = (int)(Math.random() * 360);
        myColor = c;
        xCorners = new int[corners];
        yCorners = new int[corners];
        size = (int)(Math.random() * 10) + 6;
        initPos();
        rotationSpeed = (int)(Math.random() * 6) + 1;
        createCorners();
    }
    
    public void move(){
        turn(rotationSpeed);
        //change the x and y coordinates by myXspeed and myYspeed       
        myCenterX += myXspeed;    
        myCenterY += myYspeed;   
    }
    private void createCorners(){
        createCorner(0,3,1);
        createCorner(1,-2,2);
        createCorner(2,-3,-2);
        createCorner(3,1,-4);
        createCorner(4,1,-2);
    }
    private void createCorner(int idx,int x, int y){
        xCorners[idx] = x * size;
        yCorners[idx] = y * size;
    }
    private void initPos(){
        //0 = left 1 = right 2 = down 3 = up
        switch (start){
            case 0:
                myCenterX = -size * 3;
                myCenterY = (int)(Math.random() * height);
                myYspeed = (Math.random() * 3) -1;
                myXspeed = (Math.random() * 1) + 1;
                break;
            case 1:
                myCenterX = width + size * 3;
                myCenterY = (int)(Math.random() * height);
                myYspeed = (Math.random() * 3) -1;
                myXspeed = - ((Math.random() * 1) + 1);
                break;
            case 2:
                myCenterY = height + size * 3;
                myCenterX = (int)(Math.random() * width);
                myXspeed = (Math.random() * 3) -1;
                myYspeed = - ((Math.random() * 1) +1);
                break;
            case 3:
                myCenterY = -size * 3;
                myCenterX = (int)(Math.random() * width);
                myXspeed = (Math.random() * 3) -1;
                myYspeed = (Math.random() * 1) +1;
                break;
        }
    }
    public boolean isOutofScreen(){
        if((myCenterX < -4 * size && start != 0) || (myCenterX > width + size * 4 && start !=1)){
            return true;
        }
        if((myCenterY < -4 * size && start !=3) || (myCenterY > height + size * 4 && start !=2)){
            return true;
        }
        return false;
    }

    public boolean isCollide(Spaceship ship){
        double shipx = ship.getX();
        double shipy = ship.getY();
        if(dist((float)shipx, (float)shipy, (float)myCenterX, (float)myCenterY) < size * 4 + 17){
            return true;
        }else{
            return false;
        }
    }
    public double getX(){
        return myCenterX;
    }
    public void setX(double x){
        myCenterX = x;
    }
    public double getY(){
        return myCenterY;
    }
    public void setY(double y){
        myCenterY = y;
    }
}