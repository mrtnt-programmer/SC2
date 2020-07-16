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
  boolean dead(){if (myvie < 1){return true;}else {return false;}}//suis je mort?
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
  
  void action(){  
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
  
  void debug(){//on recommance a zero pour pas de beug
    mytargetlist.clear();
    istheretarget = false;
    fill(255,255,255);
  }
  
  void horsterrain(){//si en dehort du terrain enleve
    if(mybody.x <= gamewidth/4 || mybody.x >= (gamewidth/4)*3 || mybody.y  <= gameheight/3 ||  mybody.y >= (gameheight/3)*2){//verifie si le marin est en dehord de la zone de combat
      deleteme = true;
    }
  }
  void horsconstructeur(){
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
  
  void mouvement(){
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
  
  void detection(float zonedetection){////doit etre donne le diametre du cercle de detection////////////////////////a optimiser//////////////////////////////////////////////////////////////////////
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
  
  void tirs(){
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
  
  void afficher(){

    ellipseMode(CENTER);
  if(myteam==1){fill(0,0,255);}
  if(myteam==2){fill(255,0,0);}
    circle(mybody.x+locationX,mybody.y+locationY,mysize);//radius = 5pix ou width/384

  }
  
  void degat(int nombrededegat){
    if (!(spawn)){
      myvie = myvie - nombrededegat;
    }
  }
}
