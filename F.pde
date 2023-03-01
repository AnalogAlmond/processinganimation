float x = 0;//grid's line end point coordinates
float y = 0;
float rx = 0;//grid's x rotation
float spacing = 195.14; //spacing in between grid lines
float ty = 0;//grid's y offset
float tya = 300;//secondary grid's secondary y offset
boolean b1 = false;
boolean b2 = false;
boolean b3 = false;
float scale = 2;//concentric circle scale
float cx = -200;//concentric circle coordinates
float cy = -200;
float angle = 0;//whole screen z rotation angle
float radius = 300;//radius of circle around which concentric circles rotate
float alpha = 0;//angle of concentric circle's rotation
float weight = 8;//concentric circle's line weight
float ls = 0;//line start point
float le = 0;//line end point
float[] size = {75,150,225,300,375};//radii of concentric circles
float[] dx = {0,0,0,0,0};//coordinates of circles
float[] dy = {0,0,0,0,0};
float tside = 30;//length of equilateral triangle's side
float desc = 30;//amount of descension for equilateral triangle
float[] triangle = {0,0,0,0,0,0};//equilateral triangle coordinates

void setup() {
  size(1366, 768,P3D);//monitor size
  background(0,20,0);//rgb values for bg
  noFill();//doesn't fill in shapes
  stroke(32,194,14);//line color
  strokeWeight(8);//line thickness
  smooth();
}

void grid(float x, float y, float tx, float ty, float rx, float ry, float rz){
    pushMatrix();
    translate(tx,ty);//shifts grid in space
    rotateX(rx);//rotates grid toward/away from the viewer
    rotateY(ry);//rotates grid to the right/left
    rotateZ(rz);//rotates grid around the screen plane
    
    //draws lines that make up grid
    for(float i = 0; i <= width*2; i+=spacing){
      line(i,0,i,x);
    }
    for(float i = 0; i <= height*2; i+=spacing){
      line(0,i,y,i);
    }
    ty++;
    popMatrix();
}

void conc(float x, float y, float scale,float weight({
  pushStyle();//ensures that stroke weight only changes for this object
  strokeWeight(weight);
  int step = 50;//spacing between circles
  int start = 50;//size of smallest circle
  //draws 5 concentric circles
  for(int i = 0; i < 5; i++){
    ellipse(x,y,(start+step*i)*scale,(start+step*i)*scale);
  }
  popStyle();
}


void draw(){
  background(0,20,0);//refreshes bg every frame
  //DRAW GRID
  if(x<height|| y<width){
    grid(x,y,0,0,0,0,0);
    if(x<=height)x+=20;
    if(y<=width)y+=20;
    ty = -height / 2;
    for(int i = 0; i < 5; i++){
      dx[i]=width/2;
      dy[i]=height/2;
    }
  }
  else if(!(b1&&b2&&b3)){
    pushMatrix();
    translate(width/2,height/2);
    //BEGIN GRID ROTATION
    rotateZ(radians(angle));
    if(angle>=-360){
      grid(height*2,width*2,-width/2,ty,rx,0,0);
      angle-=0.5;
    }
    //AT ANGLE = -160, DRAW SECONDARY GRID
    if((angle<=-140)&&(angle>=-360)){
      grid(height*2,width*2,width/2,-ty-tya,-rx,0,radians(180));
      if(tya>=0)tya-=5;//makes secondadry grid rise from offscreen
    }
    if((ty<=height/3)&&(angle>=-360))ty+=5; 
      else b1=true;
    if((rx<=PI/3)&&(angle>=-360))rx+=0.01; 
      else b2=true;
    if(angle<=-360){//after a full rotation is completed, make grids rise
      grid(height*2,width*2,-width/2,ty,rx,0,0);
      grid(height*2,width*2,width/2,-ty,-rx,0,radians(180));
      if(ty>0)ty-=10;
      if(rx <= PI/2-radians(1.5)) rx+=0.01;
    }
     popMatrix();
    //CIRCLE MOVEMENT
    if((cy<height/2+radius)&&(cx<width/2)){//initial linear movement phase
      conc(cx,cy,scale,weight);
      cy+=4;
      cx+=4;
    }
    else{
      //CIRCLE ROTATION
      conc(width/2+sin(alpha)*radius,height/2+cos(alpha)*radius,scale,weight);
      if(radius>0) radius-=0.7;//todo: make initial radius smaller and make the reduction in radius slower
      if(alpha<2*PI)alpha+=radians(0.5);
    }
    if((scale>=1)&&(angle>-360))scale-=0.005;//gradually shrinks circles
    //AT ANGLE = -240, ENLARGE CONCENTRIC CIRCLES' THICKNESS
    if(angle<=-240){
      if(weight<50)weight+=0.5;
    }
  }
  
  //DRAWS LINE INSTEAD OF MERGED GRIDS AND SHRINKS IT INTO CIRCLE
  if((angle<=-360)&&(rx >= PI/2-radians(1.5))){
    b1=true;
    background(0,20,0);
    conc(width/2,height/2,scale,weight);
    if(ls==0){
      le=width*2;//makes the animation delay a bit so we see the straight line
      //todo: reduce amount of delay
      ls = -width;
    }
    line(ls,height/2,le,height/2);
    if(ls <= width/2)ls+=10;
    if(le >= width/2)le-=10;
    //returns normal weight and scale
    if(ls >= 0){
      if(scale<=1.5)scale+=0.01;
      if(weight>=8)weight-=1;
    }
  }
  
  if((weight<=8)&&(angle<=-360)&&(b2)){
    background(0,20,0);
    for(int i = 0; i < 5; i++){
      ellipse(dx[i],dy[i],size[i],size[i]);
    }
    //ENLARGE AND SPLIT CIRCLES
    for(int i = 0; i < 5; i++){
      if((size[i]<400)&&(dx[1]<=3*width/4-75))size[i]+=5-i;//makes sure they all grow in proportional speeds
    }
    if(dx[1]<=3*width/4-75)dx[1]+=2;//upper right
    if(dy[1]>=height/4+75)dy[1]--;
    if(dx[2]>=width/4+75)dx[2]-=2;//upper left
    if(dy[2]>=height/4+75)dy[2]--;
    if(dx[3]<=3*width/4-75)dx[3]+=2;//lower right
    if(dy[3]<=3*height/4-75)dy[3]++;
    if(dx[4]>=width/4+75)dx[4]-=2;//lower left
    else b2 = false;
    if(dy[4]<=3*height/4-75)dy[4]++;
    else b1 = false;
  }
  
  if(dx[1]>=3*width/4-75){
    for(int i = 0; i < 5; i++){
      ellipse(dx[i],dy[i],size[i],size[i]);
    }
    for(int i = 0; i < 5; i++){
      if(size[i]>100)size[i]--;
    }
    //TRIANGLE
    if(size[0]<300){
        triangle(width/2 + triangle[0],height/2+triangle[1]+desc,width/2+triangle[2],height/2+triangle[3]+desc,width/2+triangle[4],height/2+triangle[5]+desc);
        triangle[1] = sqrt(pow(tside,2)-pow(tside/2,2))/2;
        triangle[2] = -tside/2;
        triangle[3] = -sqrt(pow(tside,2)-pow(tside/2,2))/2;
        triangle[4] = tside/2;
        triangle[5] = -sqrt(pow(tside,2)-pow(tside/2,2))/2;
        if(tside <= 230) tside+=5;
        //WELCOME
        if(tside >= 220){
            pushStyle();
            textSize(100);
            fill(32,194,14);
            textAlign(CENTER);
            text("WELCOME",width/2,150);//todo: change font
            popStyle();
        }
    }
  }
}
