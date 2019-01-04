pragma solidity ^0.5.0;

contract customModifier {
    address private owner;
    uint public ownerVariable;
    constructor() public{
        owner =  msg.sender;
    }
    modifier notOwner{
        require(msg.sender!=owner);
        emit securityBreach(msg.sender);
        _;
    }
    
    event securityBreach(address hacker);

    modifier ownerOnly {
        assert(msg.sender == owner);
        _;
    }
    function setOwnerVariable(uint number) public ownerOnly notOwner{
            ownerVariable = number;
    }
    function getOwnnerVariable() public view returns (uint){
        return ownerVariable;
    }
}
