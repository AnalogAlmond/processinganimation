float x = 0;//grid's line end point coordinates
float y = 0;
float rx = 0;//grid's x rotation
float spacing = 195.14; //spacing in between grid lines
float ty = 0;//grid's y offset
float tya = 400;//secondary grid's initial y offset
float scale = 2;//concentric circle scale
float cx = -200;//concentric circle coordinates
float cy = -200;
float angle = 0;//whole screen z rotation angle
float radius = 230;//radius of circle around which concentric circles rotate
float alpha = 0;//angle of concentric circle's rotation
float weight = 8;//concentric circle's line weight
float ls = 0;//line start point
float[] size = {75,150,225,300,375};//radii of concentric circles
float[] dx = {0,0,0,0,0};//coordinates of circles
float[] dy = {0,0,0,0,0};
float tside = 30;//length of equilateral triangle's side
float desc = 30;//amount of descension for equilateral triangle
float[] triangle = {0,0,0,0,0,0};//equilateral triangle coordinates

PFont font;
int bgr = 0;//background colors in rgb
int bgg = 20;
int bgb = 0;

void setup() {
  size(1366, 768,P3D);//monitor size
  background(bgr,bgg,bgb);//rgb values for bg
  noFill();//doesn't fill in shapes
  stroke(32,194,14);//line color
  strokeWeight(8);//line thickness
  smooth();
  font = createFont("RussoOne-Regular.ttf",90);
  //frameRate(24);
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
    for(float i = 0; i <= height*2+spacing; i+=spacing){
      line(0,i,y,i);
    }
    ty++;
    popMatrix();
}

void conc(float x, float y, float scale,float weight){
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
  background(bgr,bgg,bgb);//refreshes bg every frame
  //DRAW GRID
  if(x<=height || y<=width){
    grid(x,y,0,0,0,0,0);
    if(x<=height)x+=height/27;
    if(y<=width)y+=width/27;
    ty = -height / 2;
    for(int i = 0; i < 5; i++){
      dx[i]=width/2;
      dy[i]=height/2;
    }
  }
  else if(x>=height && y>=width){
    pushMatrix();
    translate(width/2,height/2);
    //BEGIN GRID ROTATION
    rotateZ(radians(angle));
    if(angle>=-360){
      grid(height*2,width*2,-width/2,ty,rx,0,0);
      angle -= 360.0/720;
    }
    //AT ANGLE = -130, DRAW SECONDARY GRID
    if((angle<=-130)&&(angle>=-360)){
      grid(height*2,width*2,width/2,-ty-tya,-rx,0,radians(180));
      if(tya>=0)tya-=400/80;//makes secondadry grid rise from tya offscreen
    }
    if((ty<=height/3)&&(angle>=-360))ty+=5; 
      //else b1=true;
    if((rx<=PI/3)&&(angle>=-360))rx+=0.01; 
      //else b2=true;
    if(angle<=-360){//after a full rotation is completed, make grids rise
      grid(height*2,width*2,-width/2,ty,rx,0,0);
      grid(height*2,width*2,width/2,-ty,-rx,0,radians(180));
      if(ty>0)ty-=10;
      if(rx <= PI/2) rx+=PI/2/(25*PI);
    }
     popMatrix();
     
    //CIRCLE MOVEMENT
    if((cy<=height/2+radius)&&(cx<=width/2)){//initial linear movement phase
      conc(cx,cy,scale,weight);
      cy+=(height/2+radius)/110;
      cx+=(width/2)/110;
    }
   else{
      //CIRCLE ROTATION
      conc(width/2+sin(alpha)*radius,height/2+cos(alpha)*radius,scale,weight);
      if(radius>0) radius-=0.5;
      if(alpha<2*PI)alpha+=radians(360.0/720);
    }
    if((scale>=1)&&(angle>-360))scale-=1.0/200;//gradually shrinks circles
    //AT ANGLE = -270, ENLARGE CONCENTRIC CIRCLES' THICKNESS
    if(angle<=-270){
      if(weight<50)weight+=42.0/84;
    }
  }
  
  //DRAWS LINE INSTEAD OF MERGED GRIDS AND SHRINKS IT INTO CIRCLE
  if((angle<=-360)&&(rx >= PI/2-radians(1.5))){
    background(bgr,bgg,bgb);
    conc(width/2,height/2,scale,weight);
    if(ls==0) ls = -width/4;//delay
    line(ls,height/2,width-ls,height/2);
    if(ls <= width/2)ls+=10;
    //returns normal weight and scale
    if(ls > 0){
      if(scale<=1.5)scale+=0.5/50;
      if(weight>=8)weight-=42.0/42;
    }
  }
  
  if((weight<=8)&&(angle<=-360)){
    background(bgr,bgg,bgb);
    for(int i = 0; i < 5; i++){
      ellipse(dx[i],dy[i],size[i],size[i]);
    }
    //ENLARGE AND SPLIT CIRCLES
    for(int i = 0; i < 5; i++){
      if((size[i] < 400) && (dx[1] <= 3 * width / 4 - 75)) size[i] += (5-i);//makes sure they all grow in proportional speeds
    }
    if(dx[1] <= 3*width/4-75) dx[1]+=2;//upper right
    if(dy[1] >= height/4+75)  dy[1]--;
    if(dx[2] >= width/4+75)   dx[2]-=2;//upper left
    if(dy[2] >= height/4+75)  dy[2]--;
    if(dx[3] <= 3*width/4-75) dx[3]+=2;//lower right
    if(dy[3] <= 3*height/4-75)dy[3]++;
    if(dx[4] >= width/4+75)   dx[4]-=2;//lower left
    if(dy[4] <= 3*height/4-75)dy[4]++;
  }
  
  if(dx[1]>=3*width/4-75){
    for(int i = 0; i < 5; i++){
      ellipse(dx[i],dy[i],size[i],size[i]);
    }
    for(int i = 0; i < 5; i++){
      if(size[i]>100)size[i]-=300.0/60;
    }
    //TRIANGLE
    if(size[0]<300){
      triangle(width/2 + triangle[0],height/2+triangle[1]+desc,width/2+triangle[2],height/2+triangle[3]+desc,width/2+triangle[4],height/2+triangle[5]+desc);
      triangle[1] = sqrt(pow(tside,2)-pow(tside/2,2))/2;
      triangle[2] = -tside/2;
      triangle[3] = -sqrt(pow(tside,2)-pow(tside/2,2))/2;
      triangle[4] = tside/2;
      triangle[5] = -sqrt(pow(tside,2)-pow(tside/2,2))/2;
      if(tside <= 230) tside+=200/40;
      //WELCOME
      if(tside >= 220){
        pushStyle();
        textSize(100);
        fill(32,194,14);
        textAlign(CENTER);
        textFont(font);
        text("WELCOME",width/2,150);
        popStyle();
      }
    }
  }
}
