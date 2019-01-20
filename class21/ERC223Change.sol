pragma solidity ^0.5.0;

import "browser/ERC223Transfers.sol";//import transfers manager object
import "browser/ERC223Variables.sol";
import "browser/ERC223Core.sol";

contract ERC223Change{

    address private _creator;
    ERC223Core private coreManager;
    bool private coreManagerSet;
    ERC223Variables private variablesManager;
    bool private variableManagerSet;
    ERC223Transfers private transfersManager;//creates transfer manager object
    bool private transfersManagerSet; //tracks if creator set initial transfer manager
    
    uint currentId;
    mapping(uint=>changeProposal) proposals; 
    
    struct changeProposal{ 
        address newAddress; 
        uint contractID;
        mapping(address=>uint) votes;
        uint total;
        bool approved;
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
    
    //function to set the initial transfer manager
    function setTransferManager(address newTransferManager) public{
        require(msg.sender==_creator&&(!transfersManagerSet)); //requires caller is creator and was not yet set
        transfersManager=ERC223Transfers(newTransferManager); //tells the object what is the address
    }
    
    
    function transferChangeProposal(address newTransferManager) public returns (uint thisProposalId){
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
            coreManager.setTransferManager(newTransferManager);
            variablesManager.setTransferManager(newTransferManager);
        }else{
            proposals[_currentId].approved=false; 
        }
        thisProposalId=_currentId; 
    }
    
    //proposal to change the variable manager contract
    function variableChangeProposal(address newVariableManager) public returns (uint thisProposalId){
        uint myVote = variablesManager.balanceOf(msg.sender); //weight of my vote
        changeProposal memory variableChange; //creates proposal structure object in memory
        proposals[currentId]=variableChange; //saves the object above in the position of currentId on the mapping
        uint _currentId=currentId; //saves current ID for later use
        currentId++; //increases the currentId number for the next proposal
        proposals[_currentId].newAddress=newVariableManager; //stores the address of the proposed new variable manager
        proposals[_currentId].contractID=2;//id 2 means variable manager
        proposals[_currentId].votes[msg.sender]=myVote;//automatically ads my tokens to the voting
        if(myVote>(variablesManager.totalSupply()/2)){//if my voter is greater than half of the total tokens
            proposals[_currentId].approved=true;//set status as approved
            coreManager.setVariablesManager(newVariableManager, address(this));//tells the core what is the new contract
            transfersManager.setVariablesManager(newVariableManager);//tells the transfer manager the new variable manager
        }else{ //if not enough voting power
             proposals[_currentId].approved=false; //sets approval status as not yet approved
        }
        thisProposalId=_currentId; //returns the id od the proposal
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
            if(proposals[proposalId].contractID==1){//if type is transfer (id=1)
                coreManager.setTransferManager(proposals[proposalId].newAddress, address(this)); //tells core the new transfer contract
                variablesManager.setTransferManager(proposals[proposalId].newAddress); //tells variable manager new transfer contract
            } else if (proposals[proposalId].contractID==2){//if type is varaible (id=2)
                coreManager.setVariablesManager(proposals[proposalId].newAddress, address(this));//tells core the new variable manager
                transfersManager.setVariablesManager(proposals[proposalId].newAddress);//tells transfer the new variable manager
            }
        }
    }
}
