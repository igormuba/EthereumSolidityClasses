pragma solidity ^0.5.0;

contract uniqueToken{
    uint private currentId=0;
    struct ourToken{
        uint id;
        string name;
        uint value;
        address owner;
    }
    ourToken[] tokens;
    mapping(uint => address) public ownership;
    mapping(address=>uint) public balance;
    
    function tokenValue(uint _id) public view returns (uint){
        return tokens[_id].value;
    }
    
    function tokenOwnership(uint _id) public view returns(address){
        return ownership[_id];
    }
    
    function createToken(string memory _name, uint value) public{
        tokens.push(ourToken(currentId, _name, value, msg.sender));
        ownership[currentId]=msg.sender;
        currentId++;
    }
    
    function buyToken(uint _id) payable public{
        require(msg.value>=tokens[_id].value);
        balance[tokens[_id].owner]+=msg.value;
        tokens[_id].owner = msg.sender;
        ownership[_id] = msg.sender;
    }
    
    function changeValue(uint _id, uint newValue) public{
        require(ownership[_id]==msg.sender);
        tokens[_id].value=newValue;
    }
    
    function myBalance() public view returns (uint){
        return balance[msg.sender];
    }
    
    function withdraw() public{
        msg.sender.transfer(balance[msg.sender]);
    }
    
}
