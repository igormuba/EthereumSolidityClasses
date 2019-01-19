pragma solidity ^0.5.0;

import "browser/ERC223Receiver.sol";
import "browser/ERC223Variables.sol";

contract ERC223Transfers{
    
    ERC223Variables private variablesManager;
    address private _core;
    bool private _coreSet;
    address private _creator;

    
    event Transfer(address indexed from, address indexed to, uint tokens);
    
    constructor() public {
        _creator=msg.sender;
    }
    
    function setCore(address _coreAddress) public{
        require(!_coreSet);
        _coreSet=true;
        _core = _coreAddress;
    }
    
    function setVariablesManager(address _variablesManager) public{
        require(msg.sender==_creator);
        variablesManager=ERC223Variables(_variablesManager);
    }
    
    function transfer(address _sender, address _receiver, uint _amount) public returns (bool) {
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
            //sender balance
            variablesManager.setBalance(_sender, senderFinalBalance-_amount);
            //receiver balance
            variablesManager.setBalance(_receiver, variablesManager.balanceOf(_receiver)+_amount);
            emit Transfer(_sender, _receiver, _amount);
            return true;
        }else{
            return false;
        }
    }
    
    function transfer(address _sender, address _receiver, uint _amount, bytes memory _data) public returns (bool) {
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
            //sender balance
            variablesManager.setBalance(_sender, senderFinalBalance-_amount);
            //receiver balance
            variablesManager.setBalance(_receiver, variablesManager.balanceOf(_receiver)+_amount);
            emit Transfer(_sender, _receiver, _amount);
            return true;
        }else{
            return false;
        }
    }
    
    
    function transferFrom(address _caller, address _sender, address _receiver, uint _amount) public returns (bool){
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
                //change caller allowance
                variablesManager.approve(_sender, _caller, (variablesManager.allowance(_sender, _caller)-_amount));
                //sender balance
                variablesManager.setBalance(_sender, senderFinalBalance-_amount);
                //receiver balance
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
                //change caller allowance
                variablesManager.approve(_sender, _caller, (variablesManager.allowance(_sender, _caller)-_amount));
                //sender balance
                variablesManager.setBalance(_sender, senderFinalBalance-_amount);
                //receiver balance
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
