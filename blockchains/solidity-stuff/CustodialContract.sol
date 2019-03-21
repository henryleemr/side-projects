pragma solidity ^0.4.0;

contract CustodialContract{
    address client;
    bool _switch = false;
    
    //records events into the blockchain
    event updateStatus(string _msg);
    event userStatus(string _msg, address user, uint amount);
    
    function CustodialContract(){
        client = msg.sender; 
    }
    
    modifier ifClient(){
        if (msg.sender!=client){
            throw;
        }
        _;
    }
    
    //receives deposits and logs it using events
    function depositFunds() payable{
        userStatus('User has deposited money', msg.sender, msg.value);
        
    }
    
    function withdrawFunds(unit amount) ifClient {
        if (client.send(amount)){
            updateStatus('User has withdrawn money');
            _switch = true;
        }
        else{
            _switch = false;
        }
    }
    
    function getFunds() ifClient constant returns(uint){
        updateStatus('Someone called getFunds');
        return this.balance;
    }
}