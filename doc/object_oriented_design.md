# Object-Oriented Design

## Approach
1. Handle Ambiguity
  * Ask the six W's, who, what, where, when, how and why?

2. Define the Core Objects
  * Make a list of all the important component/objects for the system. An
    object deserves to be an object only when it should have its own state

3. Analyze Relationships
  * Think about inheritances and what are some common features and functions
    that we can put into a module instead of a class

4. Investigate Actions
  * Figure out the key actions and functions of each component/object.

## Design Patterns
### Singleton Class
A singleton pattern ensures that a class has only one instance and ensures
access to the instance through the application. For example, stores in Flux
architecture are singleton, every type of data should have only one instance
of store.

### Factory Method
Factory method offers an interface for creating an instance of a class, with
its subclasses deciding which class to instantiate.
