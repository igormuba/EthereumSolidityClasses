pragma solidity ^0.5.0;


contract one{
    uint myVariable;
    function initiateMyVariable(uint number) public {
        myVariable=number;
    }
    function getMyVariable() public view returns (uint){
        return myVariable;
    }
}

contract two{
    one public contractOne;
    
    constructor(address oneAddress) public{
        contractOne = one(oneAddress);
    }
    
    function setOneAddress(address oneAddress) public{
        contractOne = one(oneAddress);
    }
    
    function initiateOneVariable(uint number) public{
        contractOne.initiateMyVariable(number);
    }
    
    function addToOneVariable(uint number) public{
        contractOne.initiateMyVariable(contractOne.getMyVariable()+number);
    }
    
    function getOneVariable() public view returns (uint){
        return contractOne.getMyVariable();
    }
}
