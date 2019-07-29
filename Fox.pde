class Fox {
    int hunger;
    int reproductionNeed;
    int x;
    int y;
    
    Fox(int x, int y) {
        hunger = 5;
        reproductionNeed = 0;
        this.x = x;
        this.y = y;
    }

    void tick() {
        hunger += 2;
        reproductionNeed += 1;
    }

    void setX(int x) {
        this.x = x;
    }

    void setY(int y) {
        this.y = y;
    }

    int getX() {
        return x;
    }

    int getY() {
        return y;
    }   

    void setHunger(int hunger) {
        this.hunger = hunger;
    }

    int getHunger() {
        return hunger;
    }

    void setReproductionNeed(int reproductionNeed) {
        this.reproductionNeed = reproductionNeed;
    }

    int getReproductionNeed() {
        return reproductionNeed;
    }
}