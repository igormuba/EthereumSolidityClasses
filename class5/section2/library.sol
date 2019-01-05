pragma solidity ^0.5.0;

library uintPlus {
    
    event added(address, uint, uint, string);
    
    function plus(uint _self) public returns (uint){
        uint selfPlusOne = _self+1;
        emit added(msg.sender, _self, selfPlusOne, "plus called");
        return selfPlusOne;
    }
    function plusplus(uint _self) public returns (uint){
        uint selfPlusTwo = _self+1;
        emit added(msg.sender, _self, selfPlusTwo, "plusplus called");
        return _self += 2;
    }
}
