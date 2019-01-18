pragma solidity ^0.5.0;

import "browser/ERC223Receiver.sol";

contract ERC223Core{
    string private _tokenName;
    string private _tokenSymbol;
    address private _creator; //address of contract creator to be defined
    uint256 private _totalSupply; //total coin supply
    mapping (address => mapping (address => uint)) private _allowed; //allowance
    mapping (address => uint) private _balance; //maps an address to a balance
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    
    constructor() public{
        _tokenName = "Mutable ERC223 Token"; //sets the name of the token
        _tokenSymbol = "MTOK"; //ticker symbol of the token
        _creator = msg.sender; //the creator of the contract
        _totalSupply = 100; //sets the total supply
        _balance[_creator] = _totalSupply; //gives all the supply to the contract creator
    }
    
    function() external payable{
        require(false);
    }
    
    function decimals() public pure returns(uint){
        return 0;
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
    
    function allowance(address _owner, address _spender) public view returns (uint){
        return _allowed[_owner][_spender]; //adds to the allowance mapping
    }
    
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }
    
    function approve(address _spender, uint _amount) public returns(bool){
        _allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
    
    function transfer(address _receiver, uint _amount) public returns (bool) {
        if (_balance[msg.sender]>=_amount&&_amount>0){
            uint codeLength;
            assembly {
                codeLength := extcodesize(_receiver)
            }
            if(codeLength>0){
                bytes memory empty;
                ERC223Receiver erc223Receiver = ERC223Receiver(_receiver);
                erc223Receiver.tokenFallback(msg.sender, _amount, empty);
            }
            _balance[msg.sender]-=_amount;
            _balance[_receiver]+=_amount;
            emit Transfer(msg.sender, _receiver, _amount);
            return true;
        }else{
            return false;
        }
    }
    
    function transfer(address _receiver, uint _amount, bytes memory _data) public returns (bool) {
    if (_balance[msg.sender]>=_amount&&_amount>0){
        uint codeLength;
        assembly {
            codeLength := extcodesize(_receiver)
        }
        if(codeLength>0){
            ERC223Receiver erc223Receiver = ERC223Receiver(_receiver);
            erc223Receiver.tokenFallback(msg.sender, _amount, _data);
        }
        _balance[msg.sender]-=_amount;
        _balance[_receiver]+=_amount;
        emit Transfer(msg.sender, _receiver, _amount);
        return true;
    }else{
        return false;
    }
    }
    
    
    function transferFrom(address _sender, address _receiver, uint _amount) public returns (bool){
        if (_balance[_sender]>=_amount&&_amount>0){
            if (_allowed[_sender][msg.sender]>=_amount){
                uint codeLength;
                assembly {
                    codeLength := extcodesize(_receiver)
                }
                if(codeLength>0){
                    bytes memory empty;
                    ERC223Receiver erc223Receiver = ERC223Receiver(_receiver);
                    erc223Receiver.tokenFallback(msg.sender, _amount, empty);
                }
                _allowed[_sender][msg.sender]-=_amount;
                _balance[_sender]-=_amount;
                _balance[_receiver]+=_amount;
                emit Transfer(_sender, _receiver, _amount);
                return true;
            }else{
                return false;
            }

        }else{
            return false;
        }
    }
    
    function transferFrom(address _sender, address _receiver, uint _amount, bytes memory _data) public returns (bool){
    if (_balance[_sender]>=_amount&&_amount>0){
        if (_allowed[_sender][msg.sender]>=_amount){
           uint codeLength;
           assembly {
                codeLength := extcodesize(_receiver)
            }
            if(codeLength>0){
                ERC223Receiver erc223Receiver = ERC223Receiver(_receiver);
                erc223Receiver.tokenFallback(msg.sender, _amount, _data);
            }
            _allowed[_sender][msg.sender]-=_amount;
            _balance[_sender]-=_amount;
            _balance[_receiver]+=_amount;
            emit Transfer(_sender, _receiver, _amount);
            return true;
        }else{
            return false;
           }

    }else{
        return false;
    }
    }
}
