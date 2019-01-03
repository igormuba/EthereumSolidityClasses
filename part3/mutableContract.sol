pragma solidity ^0.5.0;


contract one{
    uint total;
    
    function doMath(uint number1, uint number2) public {
        total = number1+number2;
    }
    
    function getTotal() public view returns (uint){
        return total;
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
    
    function delegateMath(uint number1, uint number2) public{
        contractOne.doMath(number1, number2);
    }
    
    
    function getOneTotal() public view returns (uint){
        return contractOne.getTotal();
    }
}
