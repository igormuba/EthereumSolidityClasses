pragma solidity ^0.5.0;
import "browser/safeMath.sol";

contract safeMathTest is safeMath{
    function subtraction(uint _a, uint _b) public pure returns(uint){
        return safeSub(_a, _b);
    }
}
