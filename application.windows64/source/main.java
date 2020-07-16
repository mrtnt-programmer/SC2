import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {


/*

play 
loop
triger

Minim

itch.io

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


public void setup() {
  
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


public void draw() {
  frameRate(120);//de base 60fps peux aller jusqua 300
  background(0, 255, 255);
  movecamera();
  if(millis()% 100<23){//tous les seconde
    spawntime = spawntime+0.1f;
    gametime = gametime+0.1f;
  }
  terrain.TerrainMaker(locationX,locationY);//cree le terrain
  terrain.action(); //actualise les uniter/tirs
  //trouble shoting  
}

public void mousePressed(){//activated when a mouse is pressed
  if (keyCode == SHIFT){
    if (mouseButton == LEFT) {
      terrain.spawnmarin(mouseX-locationX      ,mouseY-locationY      ,2           ,1            );//bleu passif
//////clasee/.fonction//(coordonneX dans le jeu,coordonneY dans le jeu,couleur/team,Action/passif
    }
  }else{
    if (mouseButton == LEFT) {
      terrain.spawnmarin(mouseX-locationX,mouseY-locationY,1,1);//rouge passif
    } 
  }
}

public void keyPressed(){
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

public void keyReleased(){
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

public void movecamera(){
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
//class
//45hp 6degat tirs tous les 0.61 vue dee 9 peux tire de 5
class Marin{
  ArrayList<Tir>tirs;//je cree la liste de mes tirs
  Tir tir;//je cree une variable de classe pour remplire/utiliser la liste de mes tirs PEW PEW PEW
  float range;//de quel distance peux je tire?
  float sight;//de quel distance peux je voir?
  int frame;
  
  float top;//dessus de l'hitbox
  float bottom;//dessous de l'hitbox
  float left;//gauche de l'hitbox
  float right;//droit de l'hitbox
  PVector mybody;//les coordonne du millieu de l'hitbox
  PVector vitesse;//la vitesse de l'uniter
  float myvitesse;//la vitesse de mouvement
  
  int myteam;// rouge(1) ou bleu(2)
  IntList mytargetlist;//contient l'idetifiant des l'uniter dans la ligne de tir
  int mytarget;//l'uniter la plus proche dans son champ de tir
  float myvie;//combient de degat avant que je meure
  float mysize;//quelle es mon diametre?(rayon*2)
  float attackcooldown;//horloge qui dit quand on peux attacker
  float attackspeed;//variable qui contien la vitesse a lequel on tirs
  boolean istheretarget;//true if there is target false if not
  boolean combat;// ON ATTACKE!!! si c'est true...
  boolean spawn;//regard si on est dans le spawner
  public boolean dead(){if (myvie < 1){return true;}else {return false;}}//suis je mort?
  boolean deleteme = false;//je suis mort alors on m'enleve de ce mond(ou je suis invisible jusqua quond m'enleve)
    
  Marin(float Xdonne,float Ydonne,int team,int combatdonne){
  mysize = width/96;
  sight = mysize*8;
  range = 5*(sight/9);
  myteam = team;// equipe 1 ou 2
  if(myteam==1){myvitesse=width/800;}
  if(myteam==2){myvitesse=-(width/800);}
  
  mybody = new PVector(Xdonne,Ydonne);
  vitesse=new PVector(myvitesse,myvitesse);
  top = mybody.x;
  bottom = mybody.x+mysize;
  left = mybody.y;
  right =  mybody.y+mysize;
  
  if(combatdonne==1){spawn=true;}else{spawn=false;}
  if(combatdonne==2){combat=true;}else{combat=false;}
  mytargetlist = new IntList();
  attackspeed = 100;//par raport au fps (sur mon ordi 100~1sec)
  attackcooldown = attackspeed;
  istheretarget = false;
  tirs = new ArrayList<Tir>();
  myvie = 45;//regard dans strarcraft
  
  }
  
  public void action(){  
    if (spawn){
      afficher();  
      horsconstructeur();    
    }
    if (combat){
      mouvement();//on bouge!!!
      horsterrain();
      afficher();//on me vois!!!
      tirs();//on attack!!!
    }
    debug();
  }
  
  public void debug(){//on recommance a zero pour pas de beug
    mytargetlist.clear();
    istheretarget = false;
    fill(255,255,255);
  }
  
  public void horsterrain(){//si en dehort du terrain enleve
    if(mybody.x <= gamewidth/4 || mybody.x >= (gamewidth/4)*3 || mybody.y  <= gameheight/3 ||  mybody.y >= (gameheight/3)*2){//verifie si le marin est en dehord de la zone de combat
      deleteme = true;
    }
  }
  public void horsconstructeur(){
    if (myteam == 1){
      if(mybody.x <= (gamewidth/16) || mybody.x >= (gamewidth/16)*3 || mybody.y  <= gameheight/3 ||  mybody.y >= (gameheight/3)*2){//verifie si le marin est en dehord de la zone de construction
        deleteme = true;
      }
    }
    if (myteam == 2){
      if(mybody.x <= (gamewidth/16)*13 || mybody.x >= (gamewidth/16)*15 || mybody.y  <= gameheight/3 ||  mybody.y >= (gameheight/3)*2){//verifie si le marin est en dehord de la zone de construction
        deleteme = true;
      }
    }
  }
  
  public void mouvement(){
  detection(sight);
  if (istheretarget){
    detection(range);
    if (istheretarget){
      //on bouge pas et on tirs
    }else{
      vitesse.set((marins.get(mytarget).mybody.x - mybody.x),(marins.get(mytarget).mybody.y - mybody.y));//on dit ou aller
      vitesse.normalize();// on verifie que la vitesse est constante
      mybody.add(vitesse); //on bouge!!!
    }
  }else{
    vitesse.set(myvitesse,0);
    vitesse.normalize();
    mybody.add(vitesse);
  }

  }
  
  public void detection(float zonedetection){////doit etre donne le diametre du cercle de detection////////////////////////a optimiser//////////////////////////////////////////////////////////////////////
    for (int i = marins.size()-1;i >= 0;i--){//cherche tous les marins pour ceux dans la zonedetection
      if (myteam != marins.get(i).myteam){
        if(marins.get(i).combat){
          // if(mybody.x-(zonedetection/2) <= marins.get(i).right && mybody.x+(zonedetection/2) >= marins.get(i).left && mybody.y-(zonedetection/2) <= marins.get(i).bottom && mybody.y+(zonedetection/2) >= marins.get(i).top){//verifie si un enemie est dans 
          if(abs(mybody.x-marins.get(i).mybody.x)< zonedetection/2 && abs(mybody.y-marins.get(i).mybody.y)<zonedetection/2){
            mytargetlist.append(i);
          }
          //}
        }
      }
    }
    FloatList distance;
    distance = new FloatList();
    for (int i = mytargetlist.size()-1;i >= 0;i--){//cherche la distance des marin(parmie ceux dans ca zonedetection)
      distance.append(dist(mybody.x,mybody.y,marins.get(mytargetlist.get(i)).mybody.x,marins.get(mytargetlist.get(i)).mybody.y));//cherche la distance
    }
    for (int i = distance.size()-1;i >= 0;i--){//cherche le marin le plus proche(parmie ceux dans ca zonedetection)
      if (i != 0){
        if (distance.get(i) > distance.get(i-1)){
          mytargetlist.remove(i);
          distance.remove(i);
        }else{
          mytargetlist.remove(i-1);
          distance.remove(i-1);
        }
      }
    }
    if (mytargetlist.size() >= 1){
      mytarget = mytargetlist.get(0);//on a trouver!!!
      mytargetlist.clear();
      istheretarget = true;
    }else{
      istheretarget = false;
    }
  }
  
  public void tirs(){
    detection(range);
    if(istheretarget){
      if(attackcooldown <= 0){
        fill(255,0,0);
        tirs.add(new Tir(mybody.x,mybody.y,marins.get(mytarget).mybody.x,marins.get(mytarget).mybody.y,myteam));
        attackcooldown = attackspeed;
      }
    }
    if(attackcooldown > 0){
      attackcooldown--;
    }
    //on active/enleve tous les tirs
    for (int i = tirs.size()-1;i >= 0;i--){
      if (tirs.get(i).deleteme == true){
        tirs.remove(i);
      }else{
        tirs.get(i).action();
      }    
    }
  }
  
  public void afficher(){

    ellipseMode(CENTER);
  if(myteam==1){fill(0,0,255);}
  if(myteam==2){fill(255,0,0);}
    circle(mybody.x+locationX,mybody.y+locationY,mysize);//radius = 5pix ou width/384

  }
  
  public void degat(int nombrededegat){
    if (!(spawn)){
      myvie = myvie - nombrededegat;
    }
  }
}
class Terrain{
  int largeur;
  int hauteur;
  IntList marinaspawn;
  
  Terrain(int Xdonne,int Ydonne){
  largeur = Xdonne;
  hauteur = Ydonne;
  marinaspawn = new IntList();
  }
  
  public void action(){
    for (int i = marins.size()-1;i >= 0;i--){
      marins.get(i).action();
      if(marins.get(i).spawn){
        marinaspawn.append(i);
      }
      if (marins.get(i).dead() || marins.get(i).deleteme){
        marins.remove(i);
      }
    }
    if (spawntime >= 5){
       spawnterrain();
       spawntime = 0;
    }else{
      if(marinaspawn.size() >= 1 ){
        marinaspawn.clear();
      }
    }
    extra();
  }
  
  public void spawnterrain(){
    for (int i = marinaspawn.size()-1;i >= 0;i--){
      /////////////////////////////////////////////////////////////////////////////////////to optimes/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if(marins.get(marinaspawn.get(i)).myteam == 1){
        spawnmarin(marins.get(marinaspawn.get(i)).mybody.x + (gamewidth/16)*3,marins.get(marinaspawn.get(i)).mybody.y,marins.get(marinaspawn.get(i)).myteam,2);
      }
      if(marins.get(marinaspawn.get(i)).myteam == 2){
        spawnmarin(marins.get(marinaspawn.get(i)).mybody.x - (gamewidth/16)*3,marins.get(marinaspawn.get(i)).mybody.y,marins.get(marinaspawn.get(i)).myteam,2);
      }
    }
  }
   
  public void TerrainMaker(int Xdonne,int Ydonne){
    int X = Xdonne;
    int Y = Ydonne;
    fill(0,0,0);
    rect(X+largeur/4,Y+hauteur/3,largeur/2,hauteur/3);//le terrain de combat
    fill(255,0,255);
    rect(X+largeur/16,Y+hauteur/3,largeur/8,hauteur/3);//joueur1 terrain de l'armee
    rect(X+(largeur/4)*3+largeur/16,Y+hauteur/3,largeur/8,hauteur/3);//joueur2 terrain de l'armee
    
  }
  
  public void spawnmarin(float Xdonne,float Ydonne,int team,int combatdonne){
    marins.add(new Marin(Xdonne,Ydonne,team,combatdonne));////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
  
  public void extra(){
    fill(0,0,0);
    text(gametime,gamewidth/2,gameheight/26);
    text(spawntime,gamewidth/2,gameheight/20);
  }
}
class Tir{
  PVector mybody;
  PVector target;
  PVector vitesse;
  int myteam;
  boolean deleteme = false;
  float spawntime;
  
  //fonction
  Tir(float Xdonne,float Ydonne,float Xallerdonne,float Yallerdonne,int teamdonne){
    mybody = new PVector(Xdonne,Ydonne);
    myteam = teamdonne;// equipe 1 ou 2
    vitesse = new PVector(5,5);
    target = new PVector(Xallerdonne,Yallerdonne);
    spawntime = gametime;
  }
  
  public void action(){
    mouvement();
    afficher();
    detection();//regarde si on intersepte un ennemie
    tempdevie();
  }
  
  public void tempdevie(){
    if(gametime-spawntime >= 2){
      deleteme = true;
    }
  }
  
  public void mouvement(){
    vitesse.set((target.x - mybody.x),(target.y - mybody.y));
    vitesse.normalize();
    mybody.add(vitesse.x*2,vitesse.y*2);
  }
  
  public void afficher(){
    stroke(255,0,255);
    fill(255,0,255);
    point(mybody.x+locationX,mybody.y+locationY);
  }
  
  public void detection(){
    if (target.x == mybody.x && target.y == mybody.y){
      deleteme = true; 
    }
    for (int i = marins.size()-1;i >= 0;i--){
      float jesuisunesupervariable = marins.get(i).myteam;
      if (jesuisunesupervariable != myteam){
        //hibox time///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if(abs(mybody.x-marins.get(i).mybody.x)<gamewidth/192 && abs(mybody.y-marins.get(i).mybody.y)<gamewidth/192){
          marins.get(i).degat(6);
          deleteme = true;
        }
      }
    }
  }
}
Minim minim;
AudioPlayer music;
boolean playmusic = false;

ArrayList<Marin> marins;
Marin marin;
Terrain terrain;
int block;
//int gamewidth = 7680,gameheight = 4320;
int gamewidth,gameheight;
int locationX,locationY;
float spawntime;
float gametime;

boolean moveleft,moveright,moveup,movedown;
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#FF0000", "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
