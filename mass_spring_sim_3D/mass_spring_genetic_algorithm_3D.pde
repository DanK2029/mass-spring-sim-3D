import java.util.*;

Creature geneticAlgorithm(int populationSize, int numOfGenerations, int testTimeSpan, Creature baseCreature) {
  //a genetic algorithm that optimizes a given base creature
  int winningCreatureIndex = 0;
  float topFitness = 0.0;
  generationCount = 0;
  ArrayList<Creature> population = generateInitialPopulation(populationSize, baseCreature);

  do {
    println("");
    generationCount++;
    population = evaluatePopulation(population, testTimeSpan);
    println("Generation: " + generationCount);
    for (int i = 0; i < population.size(); i++) {
      println("CreatureID: " + population.get(i).id + ", Fitness: " + population.get(i).fitness);
      if (population.get(i).fitness >= topFitness) {
        topFitness = population.get(i).fitness;
        winningCreatureIndex = i;
      }
    }
    writeCreatureFile(population.get(winningCreatureIndex), "GenAlgoCreations/winningCreatures/"+ structureFileName + "/" + "test" + testNum + "/" +generationCount);
    Date genDate = new Date();
    println(genDate);
  } while (generationCount < numOfGenerations);
  
  Creature winningCreature = population.get(winningCreatureIndex);
  //writeCreatureFile(winningCreature, "latestGenAlgoCreation");
  return winningCreature;
}

ArrayList<Creature> generateInitialPopulation(int populationSize, Creature baseCreature) {
  // creates an initial population based off one creature
  println("initial creation");
  ArrayList<Creature> population = new ArrayList<Creature>();
  population.add(baseCreature);
  for (int i = 0; i < populationSize-1; i++) {
    Creature copiedCreature = baseCreature.copyCreature();
    copiedCreature.mutate();
    population.add(copiedCreature);
  }
  return population;
}


ArrayList<Creature> evaluatePopulation(ArrayList<Creature> population, int testTimeSpan) {
  // evaluates a list of creatures and gives them a fitness score
  println("evaluate population");
  
  int populationSize = population.size();
  
  for (int i = 0; i < population.size(); i++) {
    if (population.get(i).fitness == 0.0) {
      testCreature(population.get(i), testTimeSpan);
    }
  }
  
  // sort creature population based on fitness in descending order (best creature at index 0)
  Collections.sort(population, new Comparator<Creature>() {
    public int compare(Creature c1, Creature c2) {
      if (c1.fitness == c2.fitness)
        return 0;
      return c1.fitness > c2.fitness ? -1 : 1;
    }
  });
  
  // remove creatures with the lower half of fitness
  int survivingPopulationSize = (int)(population.size() * fractionToKeep);
  population.subList(survivingPopulationSize, populationSize).clear();
  /*for (int i = survivingPopulationSize; i < populationSize; i++) {
      population.remove(i);
  }*/
  
  // each creature in population has a child and mutates it those children are then added to the population
  ArrayList<Creature> newPopulation = new ArrayList<Creature>();
  
  for (int i = 0; i < populationSize - survivingPopulationSize; i++) {
    int randomIndex1 = (int) random(0, survivingPopulationSize);
    int randomIndex2 = (int) random(0, survivingPopulationSize);
    Creature parentCreature1 = population.get(randomIndex1).copyCreature();
    Creature parentCreature2 = population.get(randomIndex2).copyCreature();
    Creature newCreature = crossoverCreatures(parentCreature1, parentCreature2);
    creatureCount++;
    float mutationChance = random(0,1);
    if (mutationChance < 0.33) {
      newCreature.mutate();
    }
    newPopulation.add(newCreature);
  }
  
  population.addAll(newPopulation);
  
  // sort creature population based on fitness in accending order
  Collections.sort(population, new Comparator<Creature>() {
    public int compare(Creature c1, Creature c2) {
      if (c1.fitness == c2.fitness)
        return 0;
      return c1.fitness > c2.fitness ? -1 : 1;
    }
  });
  
  return population;
}


void testCreature(Creature c, int timeSpan) {
  // test a single creature on how it can travel right given a time span
  Creature testCreature = c.copyCreature();
  ArrayList<Creature> singleCreatureList = new ArrayList<Creature>();
  //singleCreatureList.add(c);
  singleCreatureList.add(testCreature);
  float fitness = 0.0;
  
  for (int i = 0; i < timeSpan; i++) {
    simStep(singleCreatureList);
    if (singleCreatureList.get(0).getMaxXPos() > fitness) {
      fitness = singleCreatureList.get(0).getMaxXPos();
    }
  }
  simIterStep = 0;
  time = 0.0;
  //float fitness = singleCreatureList.get(0).evaluateCreature();
  if (fitness == float("inf")) {
    fitness = 0.0;
  }
  println(c.id, fitness);
  c.fitness = fitness;
}

float[] creatureToList(Creature c) {
  // turns a creature object to a list of its mutatable parameters
  int listLength = (c.springList.size() * 2) + c.ballList.size();
  float[] list = new float[listLength];
  int listIndex = 0;
  //adding spring phase
  for (int i = 0; i < c.springList.size(); i++) {
    list[listIndex] = c.springList.get(i).phase;
    listIndex++;
  }
  
  //adding spring magnitude
  for (int i = 0; i < c.springList.size(); i++) {
    list[listIndex] = c.springList.get(i).magnitude;
    listIndex++;
  }
  
  //adding ball friction
  for (int i = 0; i < c.ballList.size(); i++) {
    list[listIndex] = c.ballList.get(i).friction;
    listIndex++;
  }
  
  return list;
}

Creature listToCreature(float[] list, Creature baseCreature) {
  // fills a list of creature paramters into an empty baseCreature
  Creature c = baseCreature.copyCreature();
  int listIndex = 0;
  //adding spring phase
  for (int i = 0; i < c.springList.size(); i++) {
    c.springList.get(i).phase = list[listIndex];
    listIndex++;
  }
  
  //adding spring magnitude
  for (int i = 0; i < c.springList.size(); i++) {
    c.springList.get(i).magnitude = list[listIndex];
    listIndex++;
  }
  
  //adding ball friction
  for (int i = 0; i < c.ballList.size(); i++) {
    c.ballList.get(i).friction = list[listIndex];
    listIndex++;
  }
  return c;
}

Creature crossoverCreatures(Creature c1, Creature c2) {
  // mixes to creature parameter lists into one list based off of one random crossover point
  float[] cList1 = creatureToList(c1);
  float[] cList2 = creatureToList(c2);
  float[] newList = new float[cList1.length];
  int crossoverPoint = (int) random(0, cList1.length);
  for (int i = 0; i < newList.length; i++) {
    if (i < crossoverPoint) {
      newList[i] = cList1[i];
    } else {
      newList[i] = cList2[i];
    }
  }
  return listToCreature(newList, c1);
}


void printPopulationIds(ArrayList<Creature> population) {
  for (int i = 0; i < population.size(); i++) {
    println(population.get(i).id);
  }
}