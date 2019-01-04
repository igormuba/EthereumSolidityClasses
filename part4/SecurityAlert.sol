pragma solidity ^0.5.0;

contract customModifier {
    address private owner;
    uint public ownerVariable;
    constructor() public{
        owner =  msg.sender;
    }
    modifier notOwner{
        require(msg.sender!=owner);
        _;
    }
    
    event securityBreach(address hacker, uint number);

    modifier ownerOnly {
        assert(msg.sender == owner);
        _;
    }
    
    
    function setOwnerVariable(uint number) public{
        if (msg.sender == owner){
            ownerChange(number);
        }
        else{
            notOwnerChange(msg.sender, number);
        }
    }
    
    function notOwnerChange(address hacker, uint number) private notOwner{
        emit securityBreach(hacker, number);
    }
    
    function ownerChange(uint number) private ownerOnly{
        ownerVariable=number;
    }
    
    function getOwnnerVariable() public view returns (uint){
        return ownerVariable;
    }
}
