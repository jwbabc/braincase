﻿package
{
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.*
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.events.ComponentEvent;
	
	public class WordSearch extends Sprite
	{
		private static const DICTIONARY_LOCATION:String = "dictionary.txt";
		private static const MINIMUM_WORD_LENGTH:Number = 3;
		private static const MINIMUM_VOWELS:Number = 2; // todo
		private static const BOARD_COLS:Number = 6;
		private static const BOARD_ROWS:Number = 6;
		private static const LETTER_BUTTON_SIZE:Number = 40;
		private static const TOTAL_TIME:Number = 60; // in seconds
		private static const POINTS_PER_WORD_LOOKUP:Array = [ null, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 ]
		private static const PERCENT_VOWELS:Number = 30;
		private static const CONSONANTS:Array = [ 	"b", "c", "d", "f", "g",
												 	"h", "j", "k", "l", "m",
												 	"n", "p", "qu","r", "s",
												 	"t", "v", "w", "x", "y",
										 			"z" ]
		private static const VOWELS:Array = 	[ "a", "e", "i", "o", "u" ];

		private var loader:URLLoader;
		private var words:Array;
		private var wordsFound:Array;
		private var inputField:TextInput;
		private var buttons:Array;
		private var wordBeingSpelled:String;
		private var wordBeingSpelledLabel:Label;
		private var lastButtonClicked:Button;
		private var submitWordButton:Button;
		private var clearWordButton:Button;
		private var scoreReport:TextArea;
		private var clockField:Label;
		private var t:Timer;	
		
		public function WordSearch() {
			wordBeingSpelled = new String();
			wordsFound = new Array();
			loadDictionary(DICTIONARY_LOCATION);
		}
		private function loadDictionary(path:String):void {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,dictionaryLoaded);
			loader.load(new URLRequest(path));
		}
		private function dictionaryLoaded(e:Event):void {
			var dictionaryText:String = String(e.target.data);
			words = dictionaryText.split(String.fromCharCode(13,10));

			setupUI();
			generateBoard(200,35,BOARD_ROWS,BOARD_COLS,LETTER_BUTTON_SIZE);
			startTimer(TOTAL_TIME);
			trace("-- Dictionary loaded -- " + words.length + " words");
		}
		private function setupUI():void {
			var format:Object = new TextFormat();
			format.font = "Georgia";
			format.size = 16;
			format.color = 0x0000FF;
			wordBeingSpelledLabel = new Label();
			wordBeingSpelledLabel.autoSize = "left";
			wordBeingSpelledLabel.move(10,10);
			wordBeingSpelledLabel.setStyle("textFormat",format);
			wordBeingSpelledLabel.text = "";
			addChild(wordBeingSpelledLabel);

			submitWordButton = new Button();
			submitWordButton.move(10,35);
			submitWordButton.setSize(175 / 2, 20);
			submitWordButton.label = "Submit";
			submitWordButton.addEventListener(MouseEvent.CLICK,submitWord);
			addChild(submitWordButton);

			clearWordButton = new Button();
			clearWordButton.move(10 + (175 / 2),35);
			clearWordButton.setSize(175 / 2, 20);
			clearWordButton.label = "Clear";
			clearWordButton.addEventListener(MouseEvent.CLICK,clearWord);
			addChild(clearWordButton);
		
			scoreReport = new TextArea();
			scoreReport.x = 10;
			scoreReport.y = 60;
			scoreReport.setSize(175,275);
			scoreReport.editable = false;
			addChild(scoreReport);
			
			clockField = new Label();
			clockField.move(200,10);
			clockField.text = "";
			addChild(clockField);
		}
		private function generateBoard(startX:Number,startY:Number,totalRows:Number,totalCols:Number,buttonSize:Number):void {
			buttons = new Array();
			var colCounter:uint;
			var rowCounter:uint;
			for(rowCounter = 0; rowCounter < totalRows; rowCounter++) {				
				for(colCounter = 0; colCounter < totalCols; colCounter++) {
					var b:Button = new Button();
					b.x = startX + (colCounter*buttonSize);
					b.y = startY + (rowCounter*buttonSize);
					b.addEventListener(MouseEvent.CLICK, letterClicked);
					b.label = getRandomLetter().toUpperCase();
					b.setSize(buttonSize,buttonSize);
					b.name = "buttonRow"+rowCounter+"Col"+colCounter;
					addChild(b);
					
					buttons.push(b);
				}
			}
		}
		private function getRandomLetter():String {
			var randomPercentNum:Number = Math.random()*100;
			var letterPool:Array = randomPercentNum > PERCENT_VOWELS ? CONSONANTS : VOWELS;
			return letterPool[Math.floor(Math.random()*letterPool.length)];
		}		
		private function letterClicked(e:MouseEvent):void {
			var b:Button = Button(e.target);
			trace("Clicked: " + b.label);			
			
			if(!lastButtonClicked) {
				startNewWord(b.label);
			}
			else if(isLegalContinuation(b,lastButtonClicked)) {
				addToSpelledWord(b.label);
			}
			else {
				startNewWord(b.label);
			}
			
			lastButtonClicked = b;
			b.enabled = false;
		}
		private function addToSpelledWord(str:String):void {
			wordBeingSpelled += str;
			wordBeingSpelledLabel.text = wordBeingSpelled;
			trace("Continuing: " + wordBeingSpelled);
		}
		private function startNewWord(str:String):void {
			trace("Starting new word: " + wordBeingSpelled);
			var i:uint;
			for(i = 0; i<buttons.length; i++) {
				buttons[i].enabled = true;
			}
			wordBeingSpelled = str;
			wordBeingSpelledLabel.text = str;
		}
		private function isLegalContinuation(prevButton:Button,currButton:Button):Boolean {
			// bug: no more than 10 rows or cols due to this string manip
			var currButtonRow:Number = Number(currButton.name.charAt(currButton.name.indexOf("Row") + 3));
			var currButtonCol:Number = Number(currButton.name.charAt(currButton.name.indexOf("Col") + 3));
			var prevButtonRow:Number = Number(prevButton.name.charAt(prevButton.name.indexOf("Row") + 3));
			var prevButtonCol:Number = Number(prevButton.name.charAt(prevButton.name.indexOf("Col") + 3));
			
			return ( (prevButtonCol == currButtonCol && Math.abs(prevButtonRow - currButtonRow) <= 1) ||
					 (prevButtonRow == currButtonRow && Math.abs(prevButtonCol - currButtonCol) <= 1) );			
		}		
		private function submitWord(e:MouseEvent):void {
			if(wordBeingSpelled.length < MINIMUM_WORD_LENGTH) {
				startNewWord("");	
				wordBeingSpelledLabel.text = "Minimum " + MINIMUM_WORD_LENGTH + " letters.";
			}
			else if(!isAlreadyFound(wordBeingSpelled)) {
				var indexOfWord:Number = searchForWord(wordBeingSpelled.toLowerCase());
				if(indexOfWord > -1) {
					wordsFound.push(wordBeingSpelled);
					startNewWord("");			
					updateScore();
					wordBeingSpelledLabel.text = "New word found!"
				}
				else {
					startNewWord("");								
					wordBeingSpelledLabel.text = "Not in dictionary."
				}
			}
			else {
				startNewWord("");			
				wordBeingSpelledLabel.text = "Already submitted."
			}
		}
		private function clearWord(e:MouseEvent):void {
			startNewWord("");	
		}

		private function isAlreadyFound(word:String):Boolean {
			var i:uint;
			for(i = 0; i<wordsFound.length; i++) {
				if(word == wordsFound[i]) return true;	
			}
			return false;
		}
		private function searchForWord(str:String):Number {
			if(words && str) {
				var i:uint = 0
				for(i=0; i<words.length; i++) {
					var thisWord:String = words[i];
					if(str == words[i]) {
						return i;	
					}
				}
				return -1;
			}
			else {
				trace("WARNING: cannot find words, or string supplied is null");
			}
			return -1;
		}		
		private function updateScore():void {
			var wordList:String = new String();
			var pointsTotal:Number = 0;
			var i:uint;
			for(i=0; i<wordsFound.length; i++) {
				var thisWord:String = wordsFound[i];
				pointsTotal += POINTS_PER_WORD_LOOKUP[thisWord.length];
				wordList += thisWord + "\n";
			}
			scoreReport.text = "Total Points: " + pointsTotal + "\n" + wordList;
		}
		private function startTimer(totalTimeToExpire:Number):void {
			t = new Timer(1000, totalTimeToExpire);
			t.addEventListener(TimerEvent.TIMER,timerTick);
			t.addEventListener(TimerEvent.TIMER_COMPLETE,timerOutOfTime);
			t.start();
		}
		private function timerTick(e:TimerEvent):void {
			var timeRemaining:Number = TOTAL_TIME - e.target.currentCount;
			clockField.text = "Time Remaining: " + String(timeRemaining);
		}
		private function timerOutOfTime(e:TimerEvent):void {
			clockField.text = "Time is up!";
			var i:uint;
			for(i=0; i<buttons.length; i++) {
				buttons[i].enabled = false;
			}
			submitWordButton.enabled = false;
			clearWordButton.enabled = false;
			wordBeingSpelledLabel.text = "";
		}
	}
}