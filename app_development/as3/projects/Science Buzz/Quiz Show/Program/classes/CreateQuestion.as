// $Id$

package {
	public class CreateQuestion {
    private var currentQuestionText:String;
		private var currentAnswerAText:String;
		private var currentAnswerBText:String;
		private var currentAnswerCText:String;
		private var currentQuestionAnswer:String;
		private var currentExplanationText:String;

		public function CreateQuestion ():void {
			currentQuestionText = "";
		  currentAnswerAText = "";
		  currentAnswerBText = "";
		  currentAnswerCText = "";
		  currentQuestionAnswer = "";
		  currentExplanationText = "";
		}
		
		// Property access
		public function get p_currentQuestionText ():String {
			return currentQuestionText;
		}
		public function set p_currentQuestionText (setValue:String):void {
			currentQuestionText = setValue;
		}
		public function get p_currentAnswerAText ():String {
			return currentAnswerAText;
		}
		public function set p_currentAnswerAText (setValue:String):void {
			currentAnswerAText = setValue;
		}
		public function get p_currentAnswerBText ():String {
			return currentAnswerBText;
		}
		public function set p_currentAnswerBText (setValue:String):void {
			currentAnswerBText = setValue;
		}
		public function get p_currentAnswerCText ():String {
			return currentAnswerCText;
		}
		public function set p_currentAnswerCText (setValue:String):void {
			currentAnswerCText = setValue;
		}
		public function get p_currentQuestionAnswer ():String {
			return currentQuestionAnswer;
		}
		public function set p_currentQuestionAnswer (setValue:String):void {
			currentQuestionAnswer = setValue;
		}
		public function get p_currentExplanationText ():String {
			return currentExplanationText;
		}
		public function set p_currentExplanationText (setValue:String):void {
			currentExplanationText = setValue;
		}
	}
}