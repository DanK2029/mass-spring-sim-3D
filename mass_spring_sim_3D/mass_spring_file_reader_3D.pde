//import java.nio.file.Path;
import java.nio.file.Paths;
BufferedReader reader; 
String line;
Creature currentCreature;

void readCreatureFile(String fileName) {
  // function to read a .txt file that holds a creatures data in it.
  // It then adds that creature to the creature list in the main file.
  try {
    reader = createReader(fileName);
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }

  while (line != null) {
    String[] words = line.split(" ");
    if (words[0].equals("creature")) {
      currentCreature = new Creature();
    } else if (words[0].equals("createCreature")) {
      creatureList.add(currentCreature);
      currentCreature = null;
    } else if (words[0].equals("massBall")) {
      float xPosition = float(words[1]);
      float yPosition = float(words[2]);
      float zPosition = float(words[3]);
      float friction = float(words[4]);
      MassBall ball;
      if (words.length == 5) {
        ball = new MassBall(xPosition, yPosition, zPosition, friction);
      } else {
        float mass = float(words[5]);
        ball = new MassBall(xPosition, yPosition, zPosition, friction, mass);
      }
      
      currentCreature.ballList.add(ball);
    } else if (words[0].equals("spring")) {
      float k = float(words[1]);
      float r = float(words[2]);
      float phase = float(words[3]);
      float magnitude = float(words[4]);
      int leftBallIndex = int(words[5]);
      int rightBallIndex = int(words[6]);  
      Spring spring = new Spring(k, r, phase, magnitude, leftBallIndex, rightBallIndex);
      currentCreature.springList.add(spring);
    } else if (words[0].equals("rod")) {
      float restLength = float(words[1]);
      int rightBallIndex = int(words[2]);
      int leftBallIndex = int(words[3]);
      Rod rod = new Rod(restLength, leftBallIndex, rightBallIndex);
      currentCreature.rodList.add(rod);
    } else if (words[0].equals("gravity")) {
      gravity = float(words[1]);
    } else if (words[0].equals("springDampeningConst")) {
      springDampeningConst = float(words[1]);
    } else if (words[0].equals("viscousDampeningConst")) {
      viscousDampeningConst = float(words[1]);
    } else if (words[0].equals("ballRadius")) {
      ballRadius = float(words[1]);
    } else if (words[0].equals("tDelta")) {
      tDelta = float(words[1]);
    } else if (words[0].equals("floorFriction")) {
      floorFriction = float(words[1]);
    } else if (words[0].equals("fitness")) {
      currentCreature.fitness = float(words[1]);
    } else if (words[0].equals("id")) {
      currentCreature.id =int(words[1]);
    } else if (words[0].equals("color")) {
      int r = int(words[1]);
      int g = int(words[2]);
      int b = int(words[3]);
      currentCreature.creatureColor = color(r, g, b);
    }
    
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }    
  }
}

void writeCreatureFile(Creature c, String fileName) {
  //writes a specific creature to a .txt file to the structure directory
  try{
    File fileWrite = new File("C:\\Users\\Daniel\\Documents\\Georgia Institute of Technology\\Spring 2017\\CS 3451\\projects\\mass_spring_sim_3D\\mass_spring_sim_3D\\structures\\" + fileName + ".txt");
    PrintWriter writer = new PrintWriter(fileWrite);
    writer.println("creature");
    
    writer.println("gravity " + gravity);
    writer.println("springDampeningConst " + springDampeningConst);
    writer.println("viscousDampeningConst " + viscousDampeningConst);
    writer.println("floorFriction " + floorFriction);
    writer.println("ballRadius " + ballRadius);
    writer.println("fitness " + c.fitness);
    writer.println("id " + c.id);
    
    for (int i = 0; i < c.ballList.size(); i++) {
      MassBall mb = c.ballList.get(i);
      writer.println("massBall " + mb.xPos + " " + mb.yPos + " " + mb.friction + " " + mb.mass);
    }
    
    for (int i = 0; i < c.springList.size(); i++) {
      Spring sp = c.springList.get(i);
      writer.println("spring " + sp.springConst + " " + sp.originalRestLength + " " + sp.phase + " " + sp.magnitude + " " + sp.rightBallIndex + " " + sp.leftBallIndex);
    }
    
    for (int i = 0; i < c.rodList.size(); i++) {
      Rod r = c.rodList.get(i);
      writer.println("rod " + r.restLength + " " + r.rightBallIndex + " " + r.leftBallIndex);
    }
    
    writer.println("createCreature");
    writer.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}