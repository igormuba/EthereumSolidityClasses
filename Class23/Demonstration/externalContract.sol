pragma solidity ^0.5.0;

contract externalContract{
    mapping(address=>uint) balance;
    
    function mint(address _caller) public{
        balance[_caller]+=10;
    }
    
    function getBalance(address _caller) public view returns (uint){
        return balance[_caller];
    }
}
