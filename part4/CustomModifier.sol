pragma solidity ^0.5.0;

contract customModifier {
    address private owner;
    uint public ownerVariable;
    constructor() public{
        owner =  msg.sender;
    }
    modifier ownerOnly {
        require(msg.sender == owner);
        _;
    }
    function setOwnerVariable(uint number) public ownerOnly{
        ownerVariable = number;
    }
    function getOwnnerVariable() public view returns (uint){
        return ownerVariable;
    }
}
