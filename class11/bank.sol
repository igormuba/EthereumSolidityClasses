pragma solidity ^0.5.0;

contract bank{
    address private _owner;
    mapping(address => uint) private _members;
    
    modifier isMember(){
        require(_members[msg.sender]>0);
        _;
    }
    
    constructor() public{
        _owner = msg.sender;
        _members[_owner] = 0;
    }
    
    function() external payable{
        _members[msg.sender]+=msg.value;
    }
    
    function withdrawal(uint amount) public isMember{
        require(_members[msg.sender]>=amount);
        msg.sender.transfer(amount);
    } 
    
    function myBalance() public isMember view returns (uint){
        return _members[msg.sender];
    }
}
