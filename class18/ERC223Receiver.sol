pragma solidity ^0.5.0;
 
contract ERC223Receiver { 
    function tokenFallback(address _from, uint _value, bytes memory _data) public;
}
