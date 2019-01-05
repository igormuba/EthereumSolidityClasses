pragma solidity ^0.5.0;

library uintPlus {
    function plus(uint _self) public pure returns (uint){
        return _self+=1;
    }
    function plusplus(uint _self) public pure returns (uint){
        return _self += 2;
    }
}
