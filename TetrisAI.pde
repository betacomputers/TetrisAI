final int CELL_SIZE = 40;
final int ROWS = 20;
final int COLS = 10;
final int FPS = 400;

// Display and simulation controls
final boolean SHOW_NETWORK = false;

// How many simulation updates to run per draw() frame.
final int SIMULATION_UPDATES_PER_FRAME = 1;

// How many ticks between automatic downward moves.
final int FALL_THRESHOLD = 1;

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

// Playfield pixel offset (calculated in setup())
int PLAYFIELD_X;
int PLAYFIELD_Y;

void settings() {
   size(1000,880); 
}

void setup() {
    frameRate(FPS);
    if(HUMAN_PLAY)
      player = new Tetris();
    else
      pop = new Population(200);

  // center the playfield horizontally and align the bottom border with the window bottom
  PLAYFIELD_X = (width - COLS*CELL_SIZE) / 2;
  // bottom border squares are drawn at PLAYFIELD_Y + ROWS*CELL_SIZE (their top),
  // and extend one CELL_SIZE further. To align border bottom with window bottom:
  PLAYFIELD_Y = height - ROWS*CELL_SIZE - CELL_SIZE;
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
      // HUD and borders are drawn inside show() so nothing else to do here
    }
    show();
}

void show() {
    
    //WALL
    stroke(100);
   int leftFrameX = PLAYFIELD_X - CELL_SIZE; // left frame area
   int rightFrameX = PLAYFIELD_X + COLS*CELL_SIZE; // right frame area (immediately right of playfield)

   // vertical frame blocks left, center divider, right
   for(int i = 0; i < ROWS+2; i++) {
     fill(120);
     rect(leftFrameX, i*CELL_SIZE + PLAYFIELD_Y - CELL_SIZE, CELL_SIZE, CELL_SIZE);
     rect(PLAYFIELD_X - CELL_SIZE, i*CELL_SIZE + PLAYFIELD_Y - CELL_SIZE, CELL_SIZE, CELL_SIZE);
     rect(rightFrameX, i*CELL_SIZE + PLAYFIELD_Y - CELL_SIZE, CELL_SIZE, CELL_SIZE);
   }

   // horizontal frame blocks (top/bottom) - draw only across the playfield extents
   int startX = PLAYFIELD_X - CELL_SIZE;
   int endX = rightFrameX; // inclusive
   int count = (endX - startX) / CELL_SIZE + 1;
   for(int i = 0; i < count; i++) {
     int x = startX + i*CELL_SIZE;
     fill(120);
     rect(x, PLAYFIELD_Y - CELL_SIZE, CELL_SIZE, CELL_SIZE);
     rect(x, PLAYFIELD_Y + ROWS*CELL_SIZE, CELL_SIZE, CELL_SIZE);
   }
   fill(255);
    textAlign(LEFT);
    textSize(30);
    // left-side HUD
    int hudLeftX = PLAYFIELD_X - 340;
    int hudRightX = PLAYFIELD_X + COLS*CELL_SIZE + 60;
    if(HUMAN_PLAY) {
      text("SCORE: "+player.score, hudLeftX, PLAYFIELD_Y + 20);
      text("LINES: "+player.lines, hudLeftX, PLAYFIELD_Y + 60);
      text("TETRIS: "+player.tetris, hudLeftX, PLAYFIELD_Y + 100);
    } else {
      text("SCORE: "+pop.best_tetris.score, hudLeftX + 60, PLAYFIELD_Y + 20);
      text("LINES: "+pop.best_tetris.lines, hudLeftX + 60, PLAYFIELD_Y + 60);
    }
    // right-side HUD
    text("GENERATION: "+pop.gen, hudRightX, PLAYFIELD_Y + 20);
    text("HIGHSCORE:\n "+highscore, hudRightX, PLAYFIELD_Y + 60);
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
