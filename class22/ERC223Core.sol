pragma solidity ^0.5.0;

import "browser/ERC223Receiver.sol";
import "browser/ERC223Transfers.sol";
import "browser/ERC223Variables.sol";

contract ERC223Core{
    ERC223Transfers private transferManager;
    bool private transferManagerSet;
    ERC223Variables private variablesManager;
    bool private variablesManagerSet;
    address private changeManagerAddress;
    bool private chageManagerSet; 
    address private _creator;
    mapping (address => uint) private _balance;
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    
    constructor() public{
        _creator = msg.sender;
    }
    
    function setTransferManager(address _transferManager, address _changeManager) public{
        require((msg.sender==_creator&&(!transferManagerSet))||msg.sender==changeManagerAddress);
        transferManagerSet=true;
        transferManager = ERC223Transfers(_transferManager);
        transferManager.setChangeManager(_changeManager);
    }
    
    function setChangeManager(address _changeManager) public{
        require(msg.sender==_creator&&(!chageManagerSet));
        chageManagerSet=true;
        changeManagerAddress=_changeManager;
    }
    
    
    function setVariablesManager(address _transferManager, address _changeManager) public{
        require((msg.sender==_creator&&(!variablesManagerSet))||msg.sender==changeManagerAddress);
        variablesManagerSet=true;
        variablesManager= ERC223Variables(_transferManager);
        variablesManager.setChangeManager(_changeManager);
    }
    
    function startVariablesManager(string memory tokenName, string memory tokenSymbol, uint totalSupply) public{
        require(msg.sender==_creator);
        variablesManager.variablesConstructor(tokenName, tokenSymbol, totalSupply);
    }
    
    function() external payable{
        require(false);
    }
    
    function decimals() public pure returns(uint){
        return 0;
    }
    
    function tokenName() public view returns(string memory){
        return variablesManager.tokenName();
    }
    
    function tokenSymbol() public view returns(string memory){
        return variablesManager.tokenSymbol();
    }
    
    function balanceOf(address _owner) public view returns(uint){
        return variablesManager.balanceOf(_owner); 
    }
    
    function allowance(address _owner, address _spender) public view returns (uint){
        return variablesManager.allowance(_owner, _spender);
    }
    
    function totalSupply() public view returns (uint) {
        return variablesManager.totalSupply();
    }
    
    function approve(address _spender, uint _amount) public returns(bool){
        return variablesManager.approve(msg.sender, _spender, _amount);
    }
    
    function transfer(address _receiver, uint _amount) public returns (bool) {
        return transferManager.transfer(msg.sender, _receiver, _amount);
    }
    
    function transfer(address _receiver, uint _amount, bytes memory _data) public returns (bool) {
        return transferManager.transfer(msg.sender, _receiver, _amount, _data);
    }
    
    
    function transferFrom(address _sender, address _receiver, uint _amount) public returns (bool){
        return transferManager.transferFrom(msg.sender, _sender, _receiver, _amount);
    }
    
    function transferFrom(address _sender, address _receiver, uint _amount, bytes memory _data) public returns (bool){
        return transferManager.transferFrom(msg.sender, _sender, _receiver, _amount, _data);
    }
}
