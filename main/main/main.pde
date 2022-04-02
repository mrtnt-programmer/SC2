void setup() {
  fullScreen();
  //noCursor();
  background(0, 0, 0);
  text("loading...", width/2, height/2);
  variableandlist();
  musicplayer();
  imageload();
}

void imageload() {
  marinstill = loadImage("marinstill.png");
  marinstill.resize(width/96, height/48);
  marinstill2 = loadImage("marinstill2.png");
  marinstill2.resize(width/96, height/48);
}

void musicplayer() {
  if (playmusic) {
    minim = new Minim(this);
    music = minim.loadFile("music.mp3");
    music.loop();
  }
}

void variableandlist() {
  block = width/96;//ou diviser par 10
  gamewidth = width;
  gameheight = height;
  // team1buildings = new ArrayList<building>();
  // team2buildings = new ArrayList<building>();
  terrain = new Terrain(gamewidth, gameheight);
  units = new ArrayList<Unit>();//list de touts les unit
  unit = new Unit(0,0,1,"marin");//unit pas utiliser dans le jeu just pur les fonction
  players = new ArrayList<Player>();//list de tout les player
  players.add(new Player(1));
  players.add(new Player(2));



}

void draw() {
  frameRate(120);//de base 60fps peux aller jusqua 300
  background(0, 255, 255);
  if (gamefinished && alreadywin) {
    terrain.victory();
  } else {
    showterrain();
  }
  
}

void debug(){
  if(find_unit_error)println("find_unit_error");find_unit_error=false;
}

void showterrain() {
  for(int i=0;i<players.size();i++){
    if(players.get(i).Qthisplayer()){
      players.get(i).spawnunit();
    }
  }
  if (rapidfire){
    click();
  }
  movecamera(); 
  camerasize();
  if (millis()% 100<23) {//tous les dixeme de seconde
    gametime = gametime+0.1;
  }
  terrain.TerrainMaker(locationX, locationY);//affiche le terrain
  if (showcadrillage){
    for(int l = 0;l<height/block;l++){
      line(0,block*l,width,block*l);
    }
    for(int c = 0;c<width/block;c++){
      line(block*c,0,block*c,height);
    } 
  }
  terrain.action(); //actualise les uniter/tirs
  terrain.baraction();//affiche la bar d'action
}  

void mousePressed() {//activated when a mouse is pressed
  if (mouseButton == LEFT) {
    click();
  }
}

void click(){
  for(int i=0;i<players.size();i++){
    if(players.get(i).Qthisplayer()){
        terrain.spawnuniter(mouseX-locationX,mouseY-locationY,players.get(i).team,selectedunit);//uniter passif
        // Unit(float Xdonne,float Ydonne,int team,String nomuniterdonne){//data
    }
  }
}

void keyPressed() {
  if (key == 'q' || key == 'Q'){
    rapidfire = true;
  }
  
  if (keyCode == ALT) {
    showcadrillage = true;
  }
  
  if (key == '1') {
    currentplayer = 1;
  }
  if (key == '2') {
    currentplayer = 2;
  }
  
  
  if (keyCode == UP) {
    moveup = true;
  }
  if (keyCode == DOWN) {
    movedown = true;
  }
  if (keyCode == LEFT) {
    moveleft = true;
  }
  if (keyCode == RIGHT) {
    moveright = true;
  }
  if (key == '+') {
    bigger = true;
  }
  if (key == '-') {
    smaller = true;
  }
  if (key == ' ') {
    gamefinished = false;
    victory1 = false;
    victory2 = false;
    alreadywin = true;
  }
}

void keyReleased() {
  if (key == 'q' || key == 'Q'){
    rapidfire = false;
  }
  if (keyCode == ALT) {
    showcadrillage = false;
    }
  if (keyCode == UP) {
    moveup = false;
  }
  if (keyCode == DOWN) {
    movedown = false;
  }
  if (keyCode == LEFT) {
    moveleft = false;
  }
  if (keyCode == RIGHT) {
    moveright = false;
  }
  if (key == '+') {
    bigger = false;
  }
  if (key == '-') {
    smaller = false;
  }
}

void movecamera() {
  if (moveup) {
    locationY = locationY + 3;
  }
  if (movedown) {
    locationY = locationY - 3;
  }
  if (moveleft) {
    locationX = locationX + 3;
  }
  if (moveright) {
    locationX = locationX - 3;
  }
}

void camerasize () {
  if (bigger == true) {
    gamewidth = gamewidth + (gamewidth/100);
    gameheight = gameheight + (gameheight/100);
  }
  if (smaller == true) {
    gamewidth = gamewidth - (gamewidth/100);
    gameheight = gameheight - (gameheight/100);
  }
}





/* void  Qgamefinished(){
 if(marin.findunit("nexus",1)){//si le nexus exist tout va bien sinon fin de la partie
 gamefinished = false;
 }else{
 gamefinished = true;
 }
 if(marin.findunit("nexus",2)){//si le nexus exist tout va bien sinon fin de la partie
 gamefinished = false;
 }else{
 gamefinished = true;
 }}
 */
