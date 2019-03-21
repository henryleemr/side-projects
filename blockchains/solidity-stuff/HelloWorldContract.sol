pragma solidity ^0.4.0;

contract HelloWorldContract {
    string word = "Hello World";
    address issuer;
    
    //this is a constructor 
    function HelloWorldContract() {
        issuer = msg.sender;
        
    }
    
    //modifiers restrict access to the function, here, setWord by setting conditions
    modifier ifIssuer() {
        if (issuer != msg.sender){
            throw;
        }
        else{
            _;
        }
    }
    //this is a getter or "browser"
    function getWord() constant returns(string) {
        return word;
    }
    //this is a setter, changes the state of the VM 
    function setWord(string newWord) ifIssuer returns(string) {
            word = newWord;
            return "This is the creator!";

    }
}