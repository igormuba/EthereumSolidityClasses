pragma solidity ^0.5.0;

import "browser/ERC20.sol";

contract ico{
    ERC20 public token; //the object where the ERC20 address will be stored
    bool public tokenSet = false; //object above is not yet set
    address public tokenCreator; //who created the ICO
    bool public icoOver = false; //if ICO is over or not
    
    constructor() public{
        tokenCreator=msg.sender; //sets token creator as the contract deployer
    }
    
    function setToken(address payable _tokenAddress) public{
        require(!tokenSet); //error if the token is already set
        require(msg.sender==tokenCreator); //the caller needs to be the ICO creator
        token=ERC20(_tokenAddress); //sets the address of an object of the type of the ERC20 contract
    }
    
    function() payable external{
        require(!icoOver); //only seels if ICO is not over yet
        uint amount = msg.value / 1 ether; //the amount of tokens sent is the amount of eth sent
        token.transfer(msg.sender, amount); //sends the amount bought to the buyer
    }
    
    function endIco() public{
        require(msg.sender==tokenCreator); //error if caller is not ICO creator
        icoOver=true; //ends the ICO
        token.clearIcoBalance();
    }
}
