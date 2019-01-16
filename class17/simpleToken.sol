pragma solidity ^0.5.0;

contract simpleToken{
    mapping(address => uint) public balance;
    address public icoAddress;
    
    constructor(address _icoAddress) public {
        icoAddress=_icoAddress;
        balance[_icoAddress]=1000;
    }
    
    function transfer(address _receiver, uint _amount) public {
        require(balance[msg.sender]>=_amount);
        require(balance[msg.sender]-_amount>=0);
        balance[msg.sender]-=_amount;
        balance[_receiver]+=_amount;
    }
    
    function createToken(address _receiver, uint _amount) public{
        require(msg.sender == icoAddress);
        require(balance[icoAddress]-_amount>=0);
        balance[icoAddress]-=_amount;
        balance[_receiver]+=_amount;
    }
    
    function getMyBalance() public view returns (uint){
        return balance[msg.sender];
    }
}
