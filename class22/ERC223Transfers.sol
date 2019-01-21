pragma solidity ^0.5.0;

import "browser/ERC223Receiver.sol";
import "browser/ERC223Variables.sol";

contract ERC223Transfers{
    
    ERC223Variables private variablesManager;
    bool private variablesManagerSet;
    address private changeManagerAddress;
    bool private chageManagerSet; 
    address private _core;
    bool private _coreSet;
    address private _creator;

    
    event Transfer(address indexed from, address indexed to, uint tokens);
    
    constructor() public {
        _creator=msg.sender;
    }
    
    //modifier to block halted accounts
    modifier notHalted {
        bool isHalted = variablesManager.checkAccountHalt(msg.sender); //loads the halt status
        require (!isHalted);//throws if account is halted
        _; //means this modifier is executed before the code of the function
    }
    
    function setCore(address payable newCoreManager)public{
        require(msg.sender==_creator&&(!_coreSet));
        _core=newCoreManager;
        _coreSet=true; 
    }
    
   
    function setVariablesManager(address _variablesManager) public{
        require((msg.sender==_creator&&(!variablesManagerSet))||msg.sender==changeManagerAddress);
        variablesManagerSet=true;
        variablesManager=ERC223Variables(_variablesManager);
    }
    
    function setChangeManager(address _changeManager) public{
        require((msg.sender==_creator&&(!chageManagerSet))||msg.sender==_core);
        chageManagerSet=true;
        changeManagerAddress=_changeManager;
    }
    
    function transfer(address _sender, address _receiver, uint _amount) public notHalted returns (bool) {
        require(msg.sender==_core);
        uint senderFinalBalance = variablesManager.balanceOf(_sender);
        if (senderFinalBalance>=_amount&&_amount>0){
            uint codeLength;
            assembly {
                codeLength := extcodesize(_receiver)
            }
            if(codeLength>0){
                bytes memory empty;
                ERC223Receiver erc223Receiver = ERC223Receiver(_receiver);
                erc223Receiver.tokenFallback(_sender, _amount, empty);
            }
            variablesManager.setBalance(_sender, senderFinalBalance-_amount);
            variablesManager.setBalance(_receiver, variablesManager.balanceOf(_receiver)+_amount);
            emit Transfer(_sender, _receiver, _amount);
            return true;
        }else{
            return false;
        }
    }
    
    function transfer(address _sender, address _receiver, uint _amount, bytes memory _data) public notHalted returns (bool) {
        require(msg.sender==_core);
        uint senderFinalBalance = variablesManager.balanceOf(_sender);
        if (senderFinalBalance>=_amount&&_amount>0){
            uint codeLength;
            assembly {
                codeLength := extcodesize(_receiver)
            }
            if(codeLength>0){
                ERC223Receiver erc223Receiver = ERC223Receiver(_receiver);
                erc223Receiver.tokenFallback(_sender, _amount, _data);
            }
            variablesManager.setBalance(_sender, senderFinalBalance-_amount);
            variablesManager.setBalance(_receiver, variablesManager.balanceOf(_receiver)+_amount);
            emit Transfer(_sender, _receiver, _amount);
            return true;
        }else{
            return false;
        }
    }
    
    
    function transferFrom(address _caller, address _sender, address _receiver, uint _amount) public notHalted returns (bool){
        require(!variablesManager.checkAccountHalt(msg.sender));
        uint senderFinalBalance = variablesManager.balanceOf(_sender);
        if (senderFinalBalance>=_amount&&_amount>0){
            if (variablesManager.allowance(_sender, _caller)>=_amount){
                uint codeLength;
                assembly {
                    codeLength := extcodesize(_receiver)
                }
                if(codeLength>0){
                    bytes memory empty;
                    ERC223Receiver erc223Receiver = ERC223Receiver(_receiver);
                    erc223Receiver.tokenFallback(_caller, _amount, empty);
                }
                variablesManager.approve(_sender, _caller, (variablesManager.allowance(_sender, _caller)-_amount));
                variablesManager.setBalance(_sender, senderFinalBalance-_amount);
                variablesManager.setBalance(_receiver, variablesManager.balanceOf(_receiver)+_amount);
                emit Transfer(_sender, _receiver, _amount);
                return true;
            }else{
                return false;
            }

        }else{
            return false;
        }
    }
    
    function transferFrom(address _caller, address _sender, address _receiver, uint _amount, bytes memory _data) public returns (bool){
        uint senderFinalBalance = variablesManager.balanceOf(_sender);
        if (senderFinalBalance>=_amount&&_amount>0){
            if (variablesManager.allowance(_sender, _caller)>=_amount){
               uint codeLength;
               assembly {
                    codeLength := extcodesize(_receiver)
                }
                if(codeLength>0){
                    ERC223Receiver erc223Receiver = ERC223Receiver(_receiver);
                    erc223Receiver.tokenFallback(_caller, _amount, _data);
                }
                variablesManager.approve(_sender, _caller, (variablesManager.allowance(_sender, _caller)-_amount));
                variablesManager.setBalance(_sender, senderFinalBalance-_amount);
                variablesManager.setBalance(_receiver, variablesManager.balanceOf(_receiver)+_amount);
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
