pragma solidity ^0.5.0;

import "browser/ERC223Transfers.sol";
import "browser/ERC223Variables.sol";
import "browser/ERC223Core.sol";

contract ERC223Change{

    address private _creator;
    ERC223Core private coreManager;
    bool private coreManagerSet;
    ERC223Variables private variablesManager;
    bool private variableManagerSet;
    ERC223Transfers private transfersManager;
    bool private transfersManagerSet; 
    
    uint currentId;
    mapping(uint=>changeProposal) proposals; 
    
    struct changeProposal{ 
        address newAddress; 
        uint contractID;
        mapping(address=>uint) votes;
        uint total;
        bool approved;
    }
    
    //modifier to block halted accounts
    modifier notHalted {
        bool isHalted = variablesManager.checkAccountHalt(msg.sender); //loads the halt status
        require (!isHalted);//throws if account is halted
        _; //means this modifier is executed before the code of the function
    }
    
    constructor() public{
        _creator=msg.sender;
    }
    
    function setCoreManager(address payable newCoreManager)public{
        require(msg.sender==_creator&&(!coreManagerSet));
        coreManager=ERC223Core(newCoreManager);
        coreManagerSet=true; 
    }
    
    function setVariableManager(address newVariableAddress) public{
        require(msg.sender==_creator&&(!variableManagerSet));
        variablesManager=ERC223Variables(newVariableAddress);
        coreManagerSet=true;
    }
    
    
    function setTransferManager(address newTransferManager) public{
        require(msg.sender==_creator&&(!transfersManagerSet)); 
        transfersManager=ERC223Transfers(newTransferManager); 
    }
    
    //add notHalted modifier
    function transferChangeProposal(address newTransferManager) public notHalted returns (uint thisProposalId) {
        uint myVote = variablesManager.balanceOf(msg.sender);
        changeProposal memory transferChange;
        proposals[currentId]=transferChange;
        uint _currentId=currentId;
        currentId++;
        proposals[_currentId].newAddress=newTransferManager;
        proposals[_currentId].contractID=1;
        proposals[_currentId].votes[msg.sender]=myVote;
        proposals[_currentId].total=myVote;
        if(myVote>(variablesManager.totalSupply()/2)){
            proposals[_currentId].approved=true;
            coreManager.setTransferManager(newTransferManager, address(this));
            variablesManager.setTransferManager(newTransferManager);
        }else{
            proposals[_currentId].approved=false;
            variablesManager.haltAccount(msg.sender);//halts user account if not enough balance
        }
        thisProposalId=_currentId; 
    }
    
    
    function variableChangeProposal(address newVariableManager) public returns (uint thisProposalId){
        uint myVote = variablesManager.balanceOf(msg.sender); 
        changeProposal memory variableChange; 
        proposals[currentId]=variableChange; 
        uint _currentId=currentId; 
        currentId++;
        proposals[_currentId].newAddress=newVariableManager; 
        proposals[_currentId].contractID=2;
        proposals[_currentId].votes[msg.sender]=myVote;
        if(myVote>(variablesManager.totalSupply()/2)){
            proposals[_currentId].approved=true;
            coreManager.setVariablesManager(newVariableManager, address(this));
            transfersManager.setVariablesManager(newVariableManager);
        }else{ 
             proposals[_currentId].approved=false; 
        }
        thisProposalId=_currentId; 
    }
    
    function getChangeProposal(uint proposalId) public view returns(address newAddressProposed, string memory contractType, uint votesFor, bool isApproved){
        changeProposal memory _changeProposal = proposals[proposalId];
        string memory contractId; 
        if (_changeProposal.contractID==1){
            contractId="transfer";
        } else if(_changeProposal.contractID==2){
            contractId="variable";
        }
        newAddressProposed=_changeProposal.newAddress; 
        contractType=contractId;
        votesFor=_changeProposal.total;
        isApproved=_changeProposal.approved;
    }
    
    function approveChange(uint proposalId) public{
        proposals[proposalId].votes[msg.sender]=variablesManager.balanceOf(msg.sender);
        proposals[proposalId].total+=variablesManager.balanceOf(msg.sender);
        if(proposals[proposalId].total>(variablesManager.totalSupply()/2)){
            proposals[proposalId].approved=true;
            if(proposals[proposalId].contractID==1){
                coreManager.setTransferManager(proposals[proposalId].newAddress, address(this)); 
                variablesManager.setTransferManager(proposals[proposalId].newAddress); 
            } else if (proposals[proposalId].contractID==2){
                coreManager.setVariablesManager(proposals[proposalId].newAddress, address(this));
                transfersManager.setVariablesManager(proposals[proposalId].newAddress);
            }
        } else{
            variablesManager.haltAccount(msg.sender);//halts user account if not enough balance
        }
    }
}
