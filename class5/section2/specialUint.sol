pragma solidity ^0.5.0;

import "browser/library.sol";

contract specialUint {
    using uintPlus for uint;
    
    function sumOne(uint number) public returns (uint){
        return number.plus();
    }
    
    function sumTwo(uint number) public returns (uint){
        return number.plusplus();
    }
    
}
