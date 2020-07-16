class Terrain{
  int largeur;
  int hauteur;
  IntList marinaspawn;
  
  Terrain(int Xdonne,int Ydonne){
  largeur = Xdonne;
  hauteur = Ydonne;
  marinaspawn = new IntList();
  }
  
  void action(){
    for (int i = marins.size()-1;i >= 0;i--){
      marins.get(i).action();
      if(marins.get(i).spawn){
        marinaspawn.append(i);
      }
      if (marins.get(i).dead() || marins.get(i).deleteme){
        marins.remove(i);
      }
    }
    if (spawntime == 61){
       spawnterrain();
       spawntime = 0;
    }else{
      if(marinaspawn.size() >= 1 ){
        marinaspawn.clear();
      }
    }
  }
  
  void spawnterrain(){
    for (int i = marinaspawn.size()-1;i >= 0;i--){
      
      /////////////////////////////////////////////////////////////////////////////////////to optimes/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if(marins.get(marinaspawn.get(i)).myteam == 1){
        spawnmarin(marins.get(marinaspawn.get(i)).mybody.x + (gamewidth/16)*3,marins.get(marinaspawn.get(i)).mybody.y + (gameheight/16)*3,marins.get(marinaspawn.get(i)).myteam,2);
      }
      if(marins.get(marinaspawn.get(i)).myteam == 2){
        spawnmarin(marins.get(marinaspawn.get(i)).mybody.x - (gamewidth/16)*3,marins.get(marinaspawn.get(i)).mybody.y - (gameheight/16)*3,marins.get(marinaspawn.get(i)).myteam,2);
      }
    }
  }
   
  void TerrainMaker(int Xdonne,int Ydonne){
    int X = Xdonne;
    int Y = Ydonne;
    fill(0,0,0);
    rect(X+largeur/4,Y+hauteur/3,largeur/2,hauteur/3);//le terrain de combat
    fill(255,0,255);
    rect(X+largeur/16,Y+hauteur/3,largeur/8,hauteur/3);//joueur1 terrain de l'armee
    rect(X+(largeur/4)*3+largeur/16,Y+hauteur/3,largeur/8,hauteur/3);//joueur2 terrain de l'armee
    
  }
  
  void spawnmarin(float Xdonne,float Ydonne,int team,int combatdonne){
    marins.add(new Marin(Xdonne,Ydonne,team,combatdonne));////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }
}
