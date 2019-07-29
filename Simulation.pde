int[][] grid;
int gridCount;
int gridSize;
ArrayList<Sheep> sheep;
ArrayList<Fox> foxes;
// 0 = water, 1 = land, 2 = plant, 3 = sheep, 4 = fox

void setup() {
    size(800, 800);
    gridCount = 32;
    gridSize = width / gridCount;
    grid = new int[gridCount][gridCount];
    sheep = new ArrayList<Sheep>();
    foxes = new ArrayList<Fox>();
    worldGen();
    noStroke();
}

void draw() {
    displayWorld();
    updateWorld();
    println("Sheep total = "+ sheep.size() + "\tFox total = " + foxes.size());
}

void worldGen() {
    // Water and land
    for(int i = 0; i < gridCount; i++) {
        for(int j = 0; j < gridCount; j++) {
            if(random(0, 1) > 0.90) {
                grid[i][j] = 0;
            } else grid[i][j] = 1;
        }    
    }
    // Edges
    for(int i = 0; i < gridCount; i++) {
        grid[i][0] = 0;
        grid[0][i] = 0;
        grid[i][gridCount - 1] = 0;
        grid[gridCount - 1][i] = 0;
    }

    for(int i = 0; i < gridCount; i++) {
        for(int j = 0; j < gridCount; j++) {
            if(grid[i][j] == 1) {
                float rand = random(0, 1);
                if(rand > 0.95) { // foxes
                    grid[i][j] = 4;
                    foxes.add(new Fox(i, j));
                } else if(rand > 0.75) { // sheep
                    grid[i][j] = 3;
                    sheep.add(new Sheep(i, j));
                } else if(rand > 0.4) { // plants
                    grid[i][j] = 2;
                } 
            }    
        }
    }
}

void displayWorld() {
    for(int i = 0; i < gridCount; i++) {
        for(int j = 0; j < gridCount; j++) {
            if(grid[i][j] == 0) {
                fill(0,0,255);
            } else if(grid[i][j] == 1){
                fill(0,255,0);
            } else if(grid[i][j] == 2){
                fill(0,100,0);
            } else if(grid[i][j] == 3) {
                fill(255);
            } else if(grid[i][j] == 4) {
                fill(255,0,0);
            }
            rect(i * gridSize, j * gridSize, gridSize, gridSize);
        }    
    }
}

void updateWorld() {
    updateSheep();
    updateVegetation();
    updateFox();
}

void updateSheep() {
    for(int i = 0; i < sheep.size(); i++) {
        Sheep s = sheep.get(i);
        s.tick();
        // check death
        if(s.getHunger() >= 10) {
            // set grid to land
            grid[s.getX()][s.getY()] = 1;
            // remove sheep
            sheep.remove(i);
        }
        // check reproduce
        else if(s.getReproductionNeed() > s.getHunger()) {
            int newX = int(random(-2, 2));
            int newY = int(random(-2, 2));
            if(grid[s.getX() + newX][s.getY() + newY] == 1) {
                grid[s.getX() + newX][s.getY() + newY] = 3;
                sheep.add(new Sheep(s.getX(), s.getY()));
                s.setX(s.getX() + newX);
                s.setY(s.getY() + newY);
                s.setReproductionNeed(0);
            }
        }
        // move + check food
        else {
            int newX = int(random(-2, 2));
            int newY = int(random(-2, 2));
            if(grid[s.getX() + newX][s.getY() + newY] == 1) {
                grid[s.getX() + newX][s.getY() + newY] = 3;
                grid[s.getX()][s.getY()] = 1;
                s.setX(s.getX() + newX);
                s.setY(s.getY() + newY);

                if(grid[s.getX() - 1][s.getY() + 1] == 2) {
                    s.setHunger(0);
                    grid[s.getX() - 1][s.getY() + 1] = 1;
                } else if(grid[s.getX()][s.getY() + 1] == 2) {
                    s.setHunger(0);
                    grid[s.getX()][s.getY() + 1] = 1;
                } else if(grid[s.getX() + 1][s.getY() + 1] == 2) {
                    s.setHunger(0);
                    grid[s.getX() + 1][s.getY() + 1] = 1;
                } else if(grid[s.getX() - 1][s.getY()] == 2) {
                    s.setHunger(0);
                    grid[s.getX() - 1][s.getY()] = 1;
                } else if(grid[s.getX() + 1][s.getY()] == 2) {
                    s.setHunger(0);
                    grid[s.getX() + 1][s.getY()] = 1;
                } else if(grid[s.getX() - 1][s.getY() - 1] == 2) {
                    s.setHunger(0);
                    grid[s.getX() - 1][s.getY() - 1] = 1;
                } else if(grid[s.getX()][s.getY() - 1] == 2) {
                    s.setHunger(0);
                    grid[s.getX()][s.getY() - 1] = 1;
                } else if(grid[s.getX() + 1][s.getY() - 1] == 2) {
                    s.setHunger(0);
                    grid[s.getX() + 1][s.getY() - 1] = 1;
                }               
            }
        }
    }
}

void updateFox() {
    for(int i = 0; i < foxes.size(); i++) {
        Fox f = foxes.get(i);
        f.tick();
        // check death
        if(f.getHunger() >= 12) {
            // set grid to land
            grid[f.getX()][f.getY()] = 1;
            // remove fox
            foxes.remove(i);
        }
        // check reproduce
        else if(f.getReproductionNeed() > f.getHunger()) {
            int newX = int(random(-2, 2));
            int newY = int(random(-2, 2));
            if(grid[f.getX() + newX][f.getY() + newY] == 1) {
                grid[f.getX() + newX][f.getY() + newY] = 4;
                foxes.add(new Fox(f.getX(), f.getY()));
                f.setX(f.getX() + newX);
                f.setY(f.getY() + newY);
                f.setReproductionNeed(0);
            }
        }
        // move + check food
        else {
            int newX = int(random(-2, 2));
            int newY = int(random(-2, 2));
            if(grid[f.getX() + newX][f.getY() + newY] == 1) {
                grid[f.getX() + newX][f.getY() + newY] = 4;
                grid[f.getX()][f.getY()] = 1;
                f.setX(f.getX() + newX);
                f.setY(f.getY() + newY);

                if(grid[f.getX() - 1][f.getY() + 1] == 3) {
                    f.setHunger(0);
                    grid[f.getX() - 1][f.getY() + 1] = 1;
                } else if(grid[f.getX()][f.getY() + 1] == 3) {
                    f.setHunger(0);
                    grid[f.getX()][f.getY() + 1] = 1;
                } else if(grid[f.getX() + 1][f.getY() + 1] == 3) {
                    f.setHunger(0);
                    grid[f.getX() + 1][f.getY() + 1] = 1;
                } else if(grid[f.getX() - 1][f.getY()] == 3) {
                    f.setHunger(0);
                    grid[f.getX() - 1][f.getY()] = 1;
                } else if(grid[f.getX() + 1][f.getY()] == 3) {
                    f.setHunger(0);
                    grid[f.getX() + 1][f.getY()] = 1;
                } else if(grid[f.getX() - 1][f.getY() - 1] == 3) {
                    f.setHunger(0);
                    grid[f.getX() - 1][f.getY() - 1] = 1;
                } else if(grid[f.getX()][f.getY() - 1] == 3) {
                    f.setHunger(0);
                    grid[f.getX()][f.getY() - 1] = 1;
                } else if(grid[f.getX() + 1][f.getY() - 1] == 3) {
                    f.setHunger(0);
                    grid[f.getX() + 1][f.getY() - 1] = 1;
                }               
            }
        }
    }
}

void updateVegetation() {
    for(int i = 0; i < gridCount; i++) {
        for(int j = 0; j < gridCount; j++) {
            if(grid[i][j] == 1) {
                float rand = random(0, 1);
                if(rand > 0.95) { // grass chance
                    grid[i][j] = 2;
                } 
            }    
        }
    }
}