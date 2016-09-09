// $Id$

/**
 * Currency Localization Class
 * A class used for formatting currency based on geologic location
 *
 * ------ General Overview ------
 * The class recieves a number to format and a country code
 * These two arguments are passed to the function formatCurrency() 
 * 
 * Currently you can pass the following country codes:
 * en-us - US Dollar - $ 123,45.75 ($ sign precedes price, ‘comma’ is used for digit group separation)
 * en-ca - Canadian Dollar - $ 123,45.75 ($ sign precedes price, ‘comma’ is used for digit group separation)
 * fr-ca - Canadian Franc - 123 45.75 $  ($ sign is after price, ‘space’ is used for digit group separation)
 * 
 * Formatted output is then placed in the output property
 * 
 * @access public
 * @author Joel Back <jwbabc@comcast.net>
 * @version 1.0
 *
 * ------ Usage ------
 * import CurrencyLocalization;
 * var country:String = myCountryCode;
 * var formattedPrice = new CurrencyLocalization(myPrice, country);
 *
 */

package {

  public class CurrencyLocalization {
    
    // The country code to format currency to
    private var country:String;
    // The formatted currency string
    private var output:String;
    // The boolean value, if the number is negative
    private var negativeValue:Boolean = false;
    
    // CurrencyLocalization constructor
		public function CurrencyLocalization (number:Number, countryCode:String):void {
      formatCurrency(number, countryCode);
    }
    
    public function formatCurrency (n:Number, code:String):void {
      // If the number is negative, set the value of negativeValue to "true"
      if (n < 0) {
        negativeValue = true;
    	}
    	n = Math.abs(n);
    	
    	// Split into whole dollars and cents
    	var dollars:Number = Math.floor(n);
    	var cents:Number = Math.round(100 * (n - dollars));
    	
    	if (cents == 100){
    		cents = 0;
    		dollars++;
    	}
    	
    	// Create the strings
    	var dollarsStr:String = String(dollars);
    	var centsStr:String;
    	var dollarsStr2:String = "";
    	
    	// Split dollar amounts into sets of 3
    	// Format dollary separation based on country code 
    	for (var i:int = 0; i < dollarsStr.length; i++){
    		if (code == "en-us" || code == "en-ca"){
      		if (i > 0 && i % 3 == 0){
      			dollarsStr2 = "," + dollarsStr2;
      		}
      		dollarsStr2 = dollarsStr.substr(-i -1, 1) + dollarsStr2;
        }
    		if (code == "fr-ca"){
      		if (i > 0 && i % 3 == 0){
      			dollarsStr2 = " " + dollarsStr2;
      		}
      		dollarsStr2 = dollarsStr.substr(-i -1, 1) + dollarsStr2;
        }
    	}	
    	
    	// Format cents
    	if (cents == 0){
    		centsStr = "00";
    	}
    	else if (cents < 10){
    		centsStr = "0" + cents;
    	}
    	else{
    		centsStr = String(cents);
    	}
    	
    	// Place dollar sign based on county code
    	if (code == "en-us" || code == "en-ca"){
      	if (negativeValue){
      	 output = "-$";
        } else {
          output = "$";
        }
        output += dollarsStr2 + "." + centsStr;
      }
    	
    	if (code == "fr-ca"){
      	output = dollarsStr2 + "." + centsStr;
      	if (negativeValue){
      	 output += "-$";
        } else {
          output += "$";
        }
      }
    }
    
    // Access to properties
    public function get p_output():String {
      return output;
    }
  }
}