final int CELL_SIZE = 40;
final int ROWS = 20;
final int COLS = 10;
final int FPS = 300;

// Display and simulation controls
final boolean SHOW_NETWORK = false;

// How many simulation updates to run per draw() frame.
final int SIMULATION_UPDATES_PER_FRAME = 1;

// How many ticks between automatic downward moves.
final int FALL_THRESHOLD = 10;

final int HIDDEN_LAYERS = 1;
final int HIDDEN_NODES = 4;

final boolean HUMAN_PLAY = false;
final boolean CHECK_NEXT = true;
final boolean GUIDE = false;

final int[][][] tetrominos = {
            {{1, 1, 1},
            {0, 1, 0}},
            
            {{0, 2, 2},
            {2, 2, 0}},
            
            {{3, 3, 0},
            {0, 3, 3}},
            
            {{4, 0, 0},
            {4, 4, 4}},
            
            {{0, 0, 5},
            {5, 5, 5}},
            
            {{6, 6, 6, 6}},
            
            {{7, 7},
            {7, 7}}
          };
          
final color[] colors = { color(0,0,0), color(127,0,127), color(0,255,0), color(255,0,0), color(0,0,255), color(255,127,0), color(0, 255,255), color(255,255,0) };

int highscore = 0;

float mutation_rate = 0.05;
float default_mutation_rate = mutation_rate;

Population pop;

Tetris player;

void settings() {
   size(920,880); 
}

void setup() {
    frameRate(FPS);
    if(HUMAN_PLAY)
      player = new Tetris();
    else
      pop = new Population(200);
}

void draw() {
    background(0);
    if(HUMAN_PLAY) {
        player.update();
        player.show_game();
        player.show_next();
        if(player.dead) {
           highscore = player.score;
           player = new Tetris(); 
        }
    } else {
    if(pop.is_done()) {
      int new_highscore = pop.find_best_tetris().score;
      if(new_highscore > highscore)
        highscore = new_highscore;
      pop.natural_selection();
    } else{
      // Advance the simulation multiple times per frame to increase base speed
      for(int i = 0; i < SIMULATION_UPDATES_PER_FRAME; i++) {
      pop.update();
      }
      pop.show(); 
    }
      stroke(0);
      fill(255);
      textSize(30);
      textAlign(LEFT);
      text("Generation : "+pop.gen,120,460);
      // text("Mutation Rate : "+mutation_rate*100+"%",120,500);
      // text("Species: "+pop.best_tetris.species_id, 120,540);
    }
    show();
}

void show() {
    
    //WALL
    stroke(100);
    for(int i = 0; i < ROWS+2; i++) {
       fill(255);
       rect(0,i*CELL_SIZE, CELL_SIZE, CELL_SIZE);
       rect(440,i*CELL_SIZE, CELL_SIZE, CELL_SIZE);
       rect(880,i*CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
    for(int i = 0; i < width/CELL_SIZE; i++) {
       fill(255);
       rect(40+i*CELL_SIZE,0, CELL_SIZE, CELL_SIZE);
       rect(40+i*CELL_SIZE,840, CELL_SIZE, CELL_SIZE);
    }
    fill(255);
    textAlign(LEFT);
    textSize(30);
    if(HUMAN_PLAY) {
      text("Score: "+player.score, 120,100);
      text("Lines: "+player.lines, 120,140);
      text("Tetris: "+player.tetris, 120,180);
    } else {
      text("Score: "+pop.best_tetris.score, 120,100);
      text("Lines: "+pop.best_tetris.lines, 120,140);
      // text("Tetris: "+pop.best_tetris.tetris, 120,180);
    }
    text("Highscore : "+highscore,120,180);
}

void keyPressed() {
  if(key == CODED && HUMAN_PLAY) {
     switch(keyCode) {
        case UP:
          player.move(0);
          break;
        case DOWN:
          player.move(1);
          break;
        case LEFT:
          player.move(2);
          break;
        case RIGHT:
          player.move(3);
          break;
     }
  }
}
