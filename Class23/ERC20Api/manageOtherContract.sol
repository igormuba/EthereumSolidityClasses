pragma solidity ^0.5.0;

contract APIContract{
    function totalSupply() public view returns (uint256) {}
    function balanceOf(address owner) public view returns (uint256) {}
    function transferFrom(address from, address to, uint256 value) public returns (bool) {}
}

contract manageOtherContract{
    APIContract erc20External;
    
    function transfer(address _externalContract, address _receiver, uint _value) public{
        erc20External=APIContract(_external);
        erc20External.transferFrom(msg.sender, _receiver, _value);
    }
}
