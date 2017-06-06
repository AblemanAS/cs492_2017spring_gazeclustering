  int w = 902;
  int h = 504;
  import processing.video.*;
  import controlP5.*; //button
  PImage back;
  Movie myMovie;
  ControlP5 cp5; //button
  boolean PlayclusterA, PlayclusterB, PlayclusterC=false; 
  boolean newP=false;
  String[] lines;
  ArrayList<PVector> pastPoints;
  Time timer;
  
  
  
  void settings() {
    size(w, h);
  }
  
  void setup() {
    cp5 = new ControlP5(this); //button
    myMovie = new Movie(this, "clip_1.avi");
  
    back = loadImage("back.png");
    timer = new Time(100/6);
    lines = loadStrings("means.txt");
    println("there are " + lines.length + " lines");
    background(0);
    smooth();
    pastPoints = new ArrayList<PVector>();
    println(PlayclusterA, PlayclusterB, PlayclusterC);
  
    //button for cluster A(best fit) 
    Button b1 = cp5.addButton("clusterA")
      .setValue(0)
      .setPosition(735, 190)
      .setSize(150, 33)  
      .setOff();
    ;
  
    b1.addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_PRESSED): 
          PlayclusterA=true; 
          println(PlayclusterA);myMovie.play();
          //break;
        }
      }
    }
    ); 
  
  
    // and add another 2 buttons
    Button b2 = cp5.addButton("clusterB")
      .setValue(100)
      .setPosition(735, 230)
      .setSize(150, 33)
      ;
  
    b2.addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_PRESSED): 
          PlayclusterB=true; 
          println(PlayclusterB);
        }
      }
    }
    ); 
  
    Button b3 = cp5.addButton("clusterC")
      .setPosition(735, 270)
      .setSize(150, 33)
      .setValue(0)
      ;
  
    b3.addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_PRESSED): 
          PlayclusterC=true; 
          println(PlayclusterC);
        }
      }
    }
    );
  }
  
  void movieEvent(Movie myMovie)
  {
    myMovie.read();
  }
  
  int a = 1;
  int prevX = 0;
  int prevY = 0;
  
  
  void draw() {
  
    if (PlayclusterA==true) {
      //myMovie.play();
      movie1();
      if(newP==true){
      a=1;
      newP=false;
      }
      //myMovie.pause();
    }
  
    if (PlayclusterB==true) {
      myMovie.play();
      movie2();
      myMovie.pause();
    }
  
    if (PlayclusterC==true) {
      myMovie.play();
      movie3();
      myMovie.pause();
    }
  }
  public void movie1() {
    timer.start();
    
    image(myMovie, 0, 0);
    String[] numbers = lines[0].split(" ");
    movie(numbers);
  }
  public void movie2() {
    timer.start();
    image(myMovie, 0, 0);
    String[] numbers = lines[1].split(" ");
    movie(numbers);
  }
  public void movie3() {
    timer.start();
    image(myMovie, 0, 0);
    String[] numbers = lines[2].split(" ");
    movie(numbers);
  }
  
  
  public void movie(String[] numbers) {
    stroke(255);
    println("startnum : ",numbers.length/2-1,a);
    fill(255, 15);
    if (a < numbers.length/2-1) {
      pastPoints.add(new PVector(Integer.parseInt(numbers[2*a-2]), Integer.parseInt(numbers[2*a-1])));
      line(Integer.parseInt(numbers[2*a]), Integer.parseInt(numbers[2*a+1]), Integer.parseInt(numbers[2*a-2]), Integer.parseInt(numbers[2*a-1]));
      a++;  
  }
    for (int i = 1; i < pastPoints.size(); i++) {
      PVector point = pastPoints.get(i);
      PVector prevpoint = pastPoints.get(i-1);
      float diameter = map(sq(i), 0, 10000, 1, 200);
      strokeWeight(3);
      ellipse(point.x, point.y, diameter, diameter);
      strokeWeight(5);
      line(point.x, point.y, prevpoint.x, prevpoint.y);
    }
    if (pastPoints.size() >= 40) {
      pastPoints.remove(0);
    }
    if (a >= numbers.length/2-1) {
      myMovie.pause();
      clear(); 
      newP = true;
      PlayclusterA=false;
      println("newP : ",newP);
      println("finnum : ",numbers.length/2-1,a);
      
    }

    while (!timer.isFinished()) {
    }
    delay(21);
  }
  
  
  