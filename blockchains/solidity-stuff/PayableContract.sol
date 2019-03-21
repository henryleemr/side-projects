pragma solidity ^0.4.0;

contract PayableContract{
    
    //constructor for receiveFunds
    function PayableContract() {
        
    }
    
    //creates a function that receives funds
    function receiveFunds() payable{
        
    }
    
    //function that returns the balance funds in this contract
    function getter() constant returns(uint) {
        return this.balance;
    }
}

