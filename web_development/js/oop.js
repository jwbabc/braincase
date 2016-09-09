function Person(fname, lname, age, eyecolor) {
  // Add the getFullName method to the Person object
  this.getFullName = function () {
    console.log (fname+' '+lname);
  };
  
  // Get the arguments of the Person constructor
  this.getArguments = function() {
    console.log('getArguments');
    console.log(arguments);
  };
  
  // Get the event target of the Person constuctor
  this.getMe = function() {
    console.log('getThis');
    console.log(this);
  };
  
  // Set the properties of the Person object
  this.fname = String(fname);
  this.lname = String(lname);
  this.age = Number(age);
  this.eyecolor = String(eyecolor);
}

function Relative(relation, fname, lname, age, eyecolor) {
  this.details = new Person(fname, lname, age, eyecolor);
  this.details.relation = String(relation);
}

Person.prototype.addRelatives = function() {
  this.relatives = new Array();
  
  for (var i = 0; i<arguments.length ; i += 1) {
    this.relatives.push(arguments[i]);
  }
};

Person.prototype.weight = function(weight) {
  this.weight = Number(weight);
};

var person1 = new Person('joel', 'back', 36, 'hazel');
var bob = new Relative('uncle', 'bob', 'trazig', 56, 'blue');
var joe = new Relative('uncle', 'joe', 'trazig', 56, 'blue');
var tom = new Relative('uncle', 'tom', 'trazig', 56, 'blue');
var dick = new Relative('uncle', 'dick', 'trazig', 56, 'blue');
var harry = new Relative('uncle', 'harry', 'trazig', 56, 'blue');

person1.addRelatives(bob, joe, tom, dick, harry);
person1.weight(126);

console.log(person1);