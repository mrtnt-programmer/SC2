import ddf.minim.*;
/*

play 
loop
triger

Minim

https://processing.org/reference/mouseReleased_.html

if(millis()% 1000<20){//de 18 a 30 (18 ca risaue de louper 30 ca le ferai une seul foit)
1000 = 1 sec

pour les <> "ou list super baleze" sont compliquer premier programe avec baleze
command:
list.get(quelcombre) au lieu de list[quelnombre]
list.size   
list.add(variable) ou avec des list list.add(new jesuisuneclasse)
list.remove(quelnombre)

rect(X,Y,width,height);
mon ecrant a 
width = 1920 pix   X
height = 1080 pix  Y
gamewidth = 7680   X
gameheight = 4320  Y
*/   


void setup() {
  fullScreen();
  //noCursor();
  background(0,0,0);
  text("loading...",width/2,height/2);
  block = width/192;//ou diviser par 10
  gamewidth = width;
  gameheight = height;
  terrain = new Terrain(gamewidth,gameheight);
  marins = new ArrayList<Marin>();
  if (playmusic){
    minim = new Minim(this);
    music = minim.loadFile("music.mp3");
    music.loop();
  } 
}


void draw() {
  frameRate(120);
  background(0, 255, 255);
  movecamera();
  if(millis()% 1000<23){
    spawntime++;
  }
  terrain.TerrainMaker(locationX,locationY);
  terrain.action(); 
  //trouble shoting  
}

void mousePressed(){//activated when a mouse is pressed
  if (keyCode == SHIFT){
    if (mouseButton == LEFT) {
      terrain.spawnmarin(mouseX-locationX,mouseY-locationY,2,2);//bleu
    }
  }else{
    if (mouseButton == LEFT) {
      terrain.spawnmarin(mouseX-locationX,mouseY-locationY,1,2);//rouge
    } 
  }
}

void keyPressed(){
  if (keyCode == UP){
    moveup = true;
  }
  if (keyCode == DOWN){
    movedown = true;
  }
  if (keyCode == LEFT){
    moveleft = true;
  }
  if (keyCode == RIGHT){
    moveright = true;
  }
}

void keyReleased(){
  if (keyCode == UP){
    moveup = false;
  }
  if (keyCode == DOWN){
    movedown = false;
  }
  if (keyCode == LEFT){
    moveleft = false;
  }
  if (keyCode == RIGHT){
    moveright = false;
  }}

void movecamera(){
  if (moveup){
    locationY = locationY - 3;
  }
  if (movedown){
    locationY = locationY + 3;
  }
  if (moveleft){
    locationX = locationX - 3;
  }
  if (moveright){
    locationX = locationX + 3;
  }
}
