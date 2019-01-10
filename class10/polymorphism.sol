pragma solidity ^0.5.0;

contract polymorphism {
    function manyforms(uint numberOne) public pure returns (uint){
        return numberOne;
    }
    function manyforms(uint numberOne, uint numberTwo) public pure returns(uint){
        return numberOne+numberTwo;
    }
    function callOneForm() public pure returns (uint){
        return manyforms(1,3);
    }
}
