pragma solidity ^0.5.0;

import "browser/ERC223Transfers.sol";
import "browser/ERC223Receiver.sol";

contract ERC223Variables{
    ERC223Transfers private transferManager;
    address private transferManagerAddress;
    string private _tokenName;
    string private _tokenSymbol;
    address private _creator; //address of contract creator to be defined
    uint256 private _totalSupply; //total coin supply
    mapping (address => mapping (address => uint)) private _allowed; //allowance
    mapping (address => uint) private _balance; //maps an address to a balance
    bool variablesConstructed;
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    
    constructor() public{
        _creator = msg.sender;
    }
    
    function setTransferManager(address _transferManager) public{
        require(msg.sender==_creator);
        transferManager=ERC223Transfers(_transferManager);
        transferManagerAddress=_transferManager;
    }
    
    function variablesConstructor(string memory tokenName, string memory tokenSymbol, uint totalSupply) public{
        require(msg.sender==_creator);
        require (!variablesConstructed);
        _tokenName=tokenName;
        _tokenSymbol=tokenSymbol;
        _totalSupply=totalSupply;
        _balance[_creator]=_totalSupply;
    }
    
    function approve(address _owner, address _spender, uint _amount) public returns(bool){
        _allowed[_owner][_spender] = _amount;
        emit Approval(_owner, _spender, _amount);
        return true;
    }
    
    function tokenName() public view returns(string memory){
        return _tokenName;
    }
    
    function tokenSymbol() public view returns(string memory){
        return _tokenSymbol;
    }
    
    function balanceOf(address _owner) public view returns(uint){
        return _balance[_owner]; //returns balance
    }
    
    function setBalance(address _owner, uint _amount) public{
        require(msg.sender==transferManagerAddress);
        _balance[_owner]=_amount;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint){
        return _allowed[_owner][_spender]; //adds to the allowance mapping
    }
    
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }
    
}
