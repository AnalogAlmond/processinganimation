float x = 0;
float y = 0;
float rx = 0;
float ry = 0;
float rz = 0;
float spacing = 195.14;
float tx = 0;
float ty = 0;
boolean b1 = false;
boolean b2 = false;
boolean b3 = false;
float scale = 2;
float cx = 0;
float cy = 0;
float angle = 0;
float radius = 300;
float alpha = 0;
float weight = 8;
float rise = 0;
float xrotation = 0;

void setup() {
  size(1366, 768,P3D);//monitor specs = 1366/768
  background(0,20,0);//rgb values for bg
  noFill();
  stroke(32,194,14);//line color
  strokeWeight(8);
  smooth();
}



void grid(float x, float y, float tx, float ty, float rx, float ry, float rz){
    pushMatrix();
    translate(tx,ty);//shifts grid down - SHOULD STAY VARIABLE
    rotateX(rx);//rotates grid toward the viewer - SHOULD STAY FIXED
    rotateY(ry);//rotates grid to the right - SHOULD STAY VARIABLE
    rotateZ(rz);
    
    for(float i = 0; i <= width*2; i+=spacing){
      line(i,0,i,x);
    }
    for(float i = 0; i <= height*2; i+=spacing){
      line(0,i,y,i);
    }
    ty++;
    popMatrix();
}

void conc(float x, float y, float scale,float weight){
  pushStyle();//ensures that stroke weight only changes for this object
  strokeWeight(weight);
  int step = 50;
  int start = 50;
  for(int i = 0; i < 5; i++){
    ellipse(x,y,(start+step*i)*scale,(start+step*i)*scale);
  }
  popStyle();
}


void draw(){
  background(0,20,0);//refresh bg every frame
  
  //DRAW GRID
  if(x<height|| y<width){
    grid(x,y,0,0,0,0,0);
    if(x<height)x+=20;
    if(y<width)y+=20;
  }
  else if(!(b1&&b2&&b3)){//ROTATE AND MOVE GRID
    pushMatrix();//push and pop matrix makes sure that the rotation and transformation dont affect further objects
    grid(height*2,width*2,0,ty,rx,ry,rz);
    if(ty<=height/1.5)ty+=5; 
    else b1=true;
    if(rx<=PI/3)rx+=0.01; 
    else b2=true;
    if(ry>=-(PI/12))ry-=0.005;
    else b3=true;
    popMatrix();
  }
  
  
  //DRAW 5 CONCENTRIC CIRCLES + START ROTATION OF GRID + CIRCLE
  if((b1&&b2)&&b3){
    pushMatrix();
    translate(width/2,height/2);
    rotateZ(radians(angle));
    grid(height*2,width*2,-width/2,ty/4,rx,ry,rz);
    if(ty<height*2)ty+=10;
    if(angle<=-150){//AT ANGLE = -150, DRAW SECONDARY GRID
      grid(height*2,width*2,width/2,-height/2,-rx-radians(10),-ry-radians(3),radians(180));//todo: grid rising, fix shitty numbers
    }
    if(angle>=-350)angle-=0.5;
    else{//AT ANGLE = -350, STOP ROTATION, CIRCLE COORDS = 0,0, AND FUSE GRIDS INTO LINE
        grid(height*2,width*2,-width/2,ty/4,rx,ry,rz);
        grid(height*2,width*2,width/2,-height/2,-rx-radians(10),-ry-radians(3),radians(180));
        conc(0,0,scale,weight);
        //make grids rise/descend towards center
        //make grid X rotation increase up to a point
        //if(rx < PI/2) rx+=0.1;
    }
     popMatrix();
  }
  
  
 //CONCENTRIC CIRCLES todo: make rotation and timing mesh with grids better, make circle come from offscreen
  if(b1&&b2&&b3){
    if((cy<height/2+radius)&&(cx<width/2)){
      conc(cx,cy,scale,weight);
      cy+=5;//todo: adjust speed
      cx+=5;
    }
    else{
      conc(width/2+sin(alpha)*radius,height/2+cos(alpha)*radius,scale,weight);
      if(radius>0) radius-=0.7;
      if(alpha<2*PI)alpha+=radians(0.5);
    }
    if(scale>=1)scale-=0.005;
    if(angle<=-240){//AT ANGLE = -240, ENLARGE CONCENTRIC CIRCLES
      if(weight<50)weight+=0.5;
    }
  }
 
  //SHRINK LINE INTO CIRCLE
  
  //SHRINK CONCENTRIC CIRCLE STROKE WEIGHT AND SPLIT INTO 5 CIRCLES
  //MAKE THE RADII EQUAL
  //SHRINK CIRCLES
  //TRIANGLE APPEAR AT CENTRAL CIRCLE'S CENTRAL POINT
  //WELCOME
  /*
  textSize(100);
  fill(32,194,14);
  text("WELCOME",400,100);
  /*
    todo
    calculate more precice numbers
    change font
  */
  //TRIANGLE ENLARGES AS CIRCLES SHRINK
}