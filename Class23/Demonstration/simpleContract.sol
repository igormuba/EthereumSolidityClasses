pragma solidity ^0.5.0;

import "browser/APIContract.sol";

contract simpleContract{
    APIContract externalContract;
    function setExternalContract(address _externalContract) public{
        externalContract=APIContract(_externalContract);
    }
    
    function mint() public{
        externalContract.mint(msg.sender);
    }
    
    function getBalance() public view returns (uint){
        externalContract.getBalance(msg.sender);
    }
}
