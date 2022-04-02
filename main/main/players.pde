class Player{
  int team;
  
  Player(int teamdonne){
    team = teamdonne;
  }
  
  boolean Qthisplayer(){
    if (currentplayer == team){
     return true;
    }
    return false;
  }
  
  void spawnunit(){
  selectedcolor = team;
  
  }
  
}
