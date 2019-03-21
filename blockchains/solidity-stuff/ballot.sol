pragma solidity ^0.4.0;

contract CallerContract{
    CalledContract tobeCalled =  CalledContract(0x9dd1e8169e76a9226b07ab9f85cc20a5e1ed44dd);
    
    function getNumber() constant returns(uint){
        tobeCalled.getNumber();
    }
    
    function getWords() constant returns(bytes32){
        tobeCalled.getWords();
    }
}

contract CalledContract{
    uint number = 69;
    bytes32 words = 'Space jam';
    
    function setNumber(uint newNumber) returns(uint){
    number = newNumber;
    }
    
    function getNumber() constant returns(uint){
    return number;
    }

    function getWords() constant returns(bytes32){
    return words;
    }
}

