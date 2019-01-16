pragma solidity ^0.5.0;

import "browser/simpleToken.sol";

contract ico{
    simpleToken public token;
    bool public tokenSet = false;
    address public tokenCreator;
    bool public icoOver = false;
    
    constructor() public{
        tokenCreator=msg.sender;
    }
    
    function setToken(address _tokenAddress) public{
        require(!tokenSet);
        require(msg.sender==tokenCreator);
        token=simpleToken(_tokenAddress);
    }
    
    function() payable external{
        require(!icoOver);
        uint amount = msg.value / 1 ether;
        token.createToken(msg.sender, amount);
    }
    
    function endIco() public{
        require(msg.sender==tokenCreator);
        icoOver=true;
    }
}
