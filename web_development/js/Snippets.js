// Good example of a closure for Javascript
var sharkList = ["Sea Pain", "Great Wheezy", "DJ Chewie", "Lil' Bitey", "Finmaster Flex", "Swim Khalifa", "Ice Teeth", "The Notorious J.A.W."];

function assignLaser(shark, sharkList) {
  return function() {
    for (var i = 0; i < sharkList.length; i++) {
      if (shark === sharkList[i]) {
        alert("Yo, " + shark + "!\n" + "Visit underwater strapping station " + (i + 1) + " for your sweet laser.");
      };
    }
  };
}

// Objects
// --- Sample 1
var superBlinders = [ ["Firestorm", 4000], ["Solar Death Ray", 6000], ["Supernova", 12000] ];

var lighthouseRock = {
  gateClosed: true,
  weaponBulbs: superBlinders,
  capacity: 30,
  secretPassageTo: "Underwater Outpost",
  numRangers: 0
};

function addRanger(location, name, skillz, station) {
  // increment the number of rangers property
  location.numRangers++;
  // add the ranger<number> property and assign a ranger object
  location["ranger" + location.numRangers] = {
    name: name,
    skillz: skillz,
    station: station
  };
	
  return lighthouseRock;
}

// call addRanger three times to add the new rangers
addRanger(lighthouseRock, "Nick Walsh", "magnification burn", 2);
addRanger(lighthouseRock, "Drew Barontini", "uppercut launch", 3);
addRanger(lighthouseRock, "Christine Wong", "bomb defusing", 1);

// --- Sample 2
var superBlinders = [ ["Firestorm", 4000], ["Solar Death Ray", 6000], ["Supernova", 12000] ];

var lighthouseRock = {
  gateClosed: true,
  weaponBulbs: superBlinders,
  capacity: 30,
  secretPassageTo: "Underwater Outpost",
  numRangers: 3,
  ranger1: {name: "Nick Walsh", skillz: "magnification burn", station: 2},
  ranger2: {name: "Drew Barontini", skillz: "uppercut launch", station: 3},
  ranger3: {name: "Christine Wong", skillz: "bomb defusing", station: 1}
};

function dontPanic(location) {
  var list = "Avast, me hearties!\n" +
             "There be Pirates nearby! Stations!\n";

  for (var i = 1; i <= location.numRangers; i++) {
    var ranger = location["ranger"+i];
    var name = ranger.name;
    var superblinder = location.weaponBulbs[ranger.station-1][0];
    list += name + ", man the " + superblinder + "!\n";
  }

  alert(list);
}

// --- Sample 3
var superBlinders = [ ["Firestorm", 4000], ["Solar Death Ray", 6000], ["Supernova", 12000] ];

var lighthouseRock = {
  gateClosed: true,
  weaponBulbs: superBlinders,
  capacity: 30,
  secretPassageTo: "Underwater Outpost",
  numRangers: 3,
  addRanger: function(name, skillz, station) {
    this.numRangers++;
    this["ranger" + this.numRangers] = {
      name: name,
      skillz: skillz,
      station: station
    };
  }
};

// -- Here we add a method outside of the initial function
lighthouseRock.addBulb = function(name, wattage) {
	lighthouseRock.weaponBulbs.push([name, wattage]);
};

lighthouseRock.addRanger("Christine Wong", "bomb defusing", 1);
lighthouseRock.addRanger("Nick Walsh", "magnification burn", 2);
lighthouseRock.addRanger("Drew Barontini", "uppercut launch", 3);

lighthouseRock.addBulb("Cylon Deathray", 24000);

// Prototypes
// --- Parent prototype of JS is: Object
// --- All of the following are inherited from the prototype Object: Array, String, Number, Function
// --- These are owned by the anchestor prototype (the object at the origin of the prototype chain)
// --- Research these higher objects and understand their functions

// --- Sample 1
var canyonCows = [
  {name: "Bessie", type: "cow", hadCalf: "Burt"},
  {name: "Donald", type: "bull", hadCalf: null},
  {name: "Esther", type: "calf", hadCalf: null},
  {name: "Burt", type: "calf", hadCalf: null},
  {name: "Sarah", type: "cow", hadCalf: "Esther"},
  {name: "Samson", type: "bull", hadCalf: null},
  {name: "Delilah", type: "cow", hadCalf: null}
];

// Add the functionality to the Array prototype object to count a type of cow in the array
Array.prototype.countCattle = function(kind) {
	var numKind = 0;
  
  for (var i = 0; i < this.length; i++) {
    if (this[i].type === kind) {
    	numKind++;
    }
  }
  
  return numKind;
};

// Classes
// --- When building a class, determine what applies to all instances, and some instances of the class to determine a good, solid class structure for inheritence
// --- Sample 1
var genericPost = {
  x: 0,
  y: 0,
  postNum: undefined,
  connectionsTo: undefined,
  sendRopeTo: function(connectedPost) {
    if (this.connectionsTo === undefined) {
      var postArray = [];
      postArray.push(connectedPost);
      this.connectionsTo = postArray;
    } else {
      this.connectionsTo.push(connectedPost);
    }
  }
};

// Create post1 and post2
var post1 = Object.create(genericPost);
var post2 = Object.create(genericPost);
// Modify the post properties
post1.x = -2;
post1.y = 4;
post1.postNum = 1;

post2.x = 5;
post2.y = 1;
post2.postNum = 2;

// Connect the posts together
post1.sendRopeTo(post2);
post2.sendRopeTo(post1);

// --- Sample 2 - Constructor
function Fencepost(x, y, postNum) {
  this.x = x;
  this.y = y;
  this.postNum = postNum;
  this.connectionsTo = [];
  this.sendRopeTo = function(connectedPost) {
    this.connectionsTo.push(connectedPost);
  };
}

// create post18, post19, and post20
var post18 = new Fencepost(-3, 4, 18);
var post19 = new Fencepost(5, -1, 19);
var post20 = new Fencepost(-2, 10, 20);

// establish post connections
post18.sendRopeTo(post19);
post18.sendRopeTo(post20);
post19.sendRopeTo(post18);
post20.sendRopeTo(post18);

// --- Sample 3 - Constructor w/ Prototype
function Fencepost(x, y, postNum) {
  this.x = x;
  this.y = y;
  this.postNum = postNum;
  this.connectionsTo = [];
}

Fencepost.prototype = function(){
  sendRopeTo = function(connectedPost) {
    this.connectionsTo.push(connectedPost);
  };
  
  removeRope = function(removeTo) {
    var temp = [];
    for (var i = 0; i < this.connectionsTo.length; i++) {
      if (this.connectionsTo[i].postNum !== removeTo) {
        temp.push(this.connectionsTo[i]);
      }
    }
    this.connectionsTo = temp;
  };
  
  movePost = function(x, y) {
    this.x = x;
    this.y = y;
  };
};

// Overriding Prototype Properties
// Find the constructor of the Fencepost
Fencepost.constructor;
// Find the prototype methods of the constructor
Fencepost.constructor.prototype;

// Measure the distance from posts using valueOf
Fencepost.prototype.valueOf = function() {
	return Math.sqrt(this.x * this.x + this.y * this.y);
};

// override the toString method
Fencepost.prototype.toString = function() {
	var list = "";
  
  for (var i = 0; i < this.connectionsTo.length; i++) {
  	list += this.connectionsTo[i].postNum + "\n";
  }
  
  return "Fence post #" + this.postNum + ":\n" +
         "Connected to posts:\n" + list +
         "Distance from ranch: " + this.valueOf() + " yards";
};

// Find the owner of a property
Object.prototype.findOwnerOfProperty = function(propName) {
  // Set the current object
  var currentObject = this;
  // Traverse the prototype chain
  while (currentObject !== null) {
    if (currentObject.hasOwnProperty(propName)) {
      // The closest object to the initial object
      return currentObject;
    } else {
      // Otherwise, go up the chain to the next prototype
      currentObject = currentObject.constructor.prototype;
    }
  }
  // If we don't find the property, we notify the caller
  return "No property found!";
};