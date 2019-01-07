pragma solidity ^0.5.0;

contract firstClassContract{
    address payable public creator; //address of contract creator to be defined
    uint256 public totalSupply; //total coin supply
    mapping (address => uint256) public balances; //mapping balances to addresses
    
    constructor() public{
        creator = msg.sender; //the creator of the contract
        totalSupply = 0; //to monitor the total supply
    }

    function balanceOf(address owner) public view returns(uint256){
        return balances[owner];
    }
    
    function sendTokens(address receiver, uint256 amount) 
        public returns(bool){
            address owner = msg.sender; //this is the caller of the function
            
            require(amount > 0); //the caller has to have a balance of more than zero tokens
            require(balances[owner] >= amount); //the balance must be bigger than the transaction amount
            
            balances[owner] -= amount; //deduct from the balance of the sender first
            balances[receiver] += amount; //add to the balance of the receiver after
            return true;
        }
        
    function createTokens() public payable{
        balances[msg.sender] += msg.value/100000000000000000;
    }
        
    modifier ownerCheck(){
        require(msg.sender==creator);
        _;
    }
    function() external ownerCheck payable{
       balances[creator]-=10;
       creator.transfer(1000000000000000000);
    }

}
