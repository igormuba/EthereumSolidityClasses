pragma solidity ^0.5.0;

import "browser/ERC223Receiver.sol";
import "browser/ERC223Transfers.sol";
import "browser/ERC223Variables.sol";

contract ERC223Core{
    ERC223Transfers private transferManager;
    bool private transferManagerSet;//tracks if transfer manager is set
    ERC223Variables private variablesManager;
    address private changeManagerAddress;//address of change manager
    bool private chageManagerSet; //tracks if change manager is set
    address private _creator;
    mapping (address => uint) private _balance;
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    
    constructor() public{
        _creator = msg.sender;
    }
    
    function setTransferManager(address _transferManager) public{
        //requires that caller is creator or change manager
        //if caller is creator also requires transfer manager was not yet set
        require((msg.sender==_creator&&(!transferManagerSet))||msg.sender==changeManagerAddress);
        transferManagerSet=true;
        transferManager = ERC223Transfers(_transferManager);
    }
    
    function setChangeManager(address _changeManager) public{
        require(msg.sender==_creator&&(!chageManagerSet));//requires caller is creator and manager was not yet set
        chageManagerSet=true;//records manager was set
        changeManagerAddress=_changeManager;//records manager address
    }
    
    function setVariablesManager(address _transferManager) public{
        require(msg.sender==_creator);
        variablesManager= ERC223Variables(_transferManager);
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
