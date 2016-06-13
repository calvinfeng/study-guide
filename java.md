# Java
Java is an object-oriented, class-based, static typed language. Syntactically it looks
like JavaScript but it works like Ruby. This is a very brief introduction, just for
the sake of reading solutions from Cracking the Coding Interview.

## Class Declaration
``` java
//public means it's accessible to the outside world
public class Animal {
  //Declaring instance variable as private, setter and getter are needed
  private int age;
  //Must specify the type of the variable for declaration
  //This is a constructor function for instantiating an instance of Animal
  public Animal(int num) {
    age = num;
  }
}
```

## Function and Method Declaration
``` java
//static means it is class function
public static void sayHello() {
  System.out.println("Hello");
}

//non-static means it is an instance method
public void sayHello() {
  System.out.println(name + " says hello");
}
```
