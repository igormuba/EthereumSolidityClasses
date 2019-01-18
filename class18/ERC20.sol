pragma solidity ^0.5.0;

import "browser/ERC223Receiver.sol";

contract ERC20{

    string public _tokenName;
    string public _tokenSymbol;
    address public creator; //address of contract creator to be defined
    uint256 public _totalSupply; //total coin supply
    mapping (address => mapping (address => uint256)) private _allowed; //allowance
    mapping (address => uint256) public balances; //maps an address to a balance
    address public ICO;
    bool public icoOver = false;

    constructor(address _ICO) public{
        _tokenName = "ERC20 Token"; //sets the name of the token
        _tokenSymbol = "ERCT"; //ticker symbol of the token
        creator = msg.sender; //the creator of the contract
        ICO = _ICO;
        _totalSupply = 100; //sets the total supply
        balances[ICO] = _totalSupply; //gives all the supply to the contract creator
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function balanceOf(address owner) public view returns(uint256){
        return balances[owner];
    }
    
    
    function clearIcoBalance() public {
        require(msg.sender == ICO); //requires that caller is the ICO contract
        balances[msg.sender]=0; //cleans the balance of the sender
        icoOver=true;
    }

    function allowance(address owner, address spender) public view returns (uint256){
        return _allowed[owner][spender]; //adds to the allowance mapping
    }
    
    

    function transfer(address receiver, uint256 amount) 
        public returns(bool){
            uint codeLength;
            assembly {
                codeLength := extcodesize(receiver)
            }
            if(codeLength>0){
                bytes memory empty;
                ERC223Receiver erc223Receiver = ERC223Receiver(receiver);
                erc223Receiver.tokenFallback(msg.sender, amount, empty);
            }
            require(icoOver||msg.sender==ICO);
            address owner = msg.sender; //this is the caller of the function
            
            require(amount > 0); //the caller has to have a balance of more than zero tokens
            require(balances[owner] >= amount); //the balance must be bigger than the transaction amount
            
            balances[owner] -= amount; //deduct from the balance of the sender first
            balances[receiver] += amount; //add to the balance of the receiver after
            return true;
        }
        
    function transferFrom(address sender, address receiver, uint256 amount) public returns(bool){
        
            uint codeLength;
            assembly {
                codeLength := extcodesize(receiver)
            }
            if(codeLength>0){
                bytes memory empty;
                ERC223Receiver erc223Receiver = ERC223Receiver(receiver);
                erc223Receiver.tokenFallback(msg.sender, amount, empty);
            }
            require(icoOver||msg.sender==ICO);
            require(amount <= _allowed[sender][msg.sender]); //requires that the caller of the function has the permission to send this value from the sender of the amount
            
            require(amount > 0); //the caller has to have a balance of more than zero tokens
            require(balances[sender] >= amount); //the balance must be bigger than the transaction amount
            
            balances[sender] -= amount; //deduct from the balance of the sender first
            balances[receiver] += amount; //add to the balance of the receiver after
            return true;
        }
        
        function() external payable{
            require(false);
        }
        function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    }
