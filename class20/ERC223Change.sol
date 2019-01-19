pragma solidity ^0.5.0;

import "browser/ERC223Variables.sol";
import "browser/ERC223Core.sol";

contract ERC223Change{//change manager

    address private _creator;//stores creator address
    ERC223Core private coreManager;//core contract object
    bool private coreManagerSet;//tracks if core has been set
    ERC223Variables private variablesManager;//variable manager object
    bool private variableManagerSet;//tracks if variable manager has been set
    
    uint currentId; //current id of proposal
    mapping(uint=>changeProposal) proposals; //list of all proposals
    
    struct changeProposal{ //proposal structure
        address newAddress; //new address (code) proposed
        //IDs: 1=transfers 2=variables
        uint contractID; //ID of the type of the contract
        mapping(address=>uint) votes;//tracks votes per address
        uint total;//total of votes for proposal
        bool approved; //tracks if change has over 50% of approval
    }
    

    
    constructor() public{
        _creator=msg.sender;//sets the deployer as creator
    }
    
    function setCoreManager(address payable newCoreManager)public{//sets core object
        require(msg.sender==_creator&&(!coreManagerSet));//can only be set once
        coreManager=ERC223Core(newCoreManager);//core object pointing to core address
        coreManagerSet=true; //records that the set was already made
    }
    
    function setVariableManager(address newVariableAddress) public{//sets variable manager
        require(msg.sender==_creator&&(!variableManagerSet));//can only be set once(by the creator)
        variablesManager=ERC223Variables(newVariableAddress);//points to the address of the manager
        coreManagerSet=true;//records that it has been set already
    }
    
    //creates a proposal for change
    function transferChangeProposal(address newTransferManager) public returns (uint thisProposalId){
        uint myVote = variablesManager.balanceOf(msg.sender);//how many tokens (votes) I own
        changeProposal memory transferChange;//proposal object (from struct)
        proposals[currentId]=transferChange;//stores the proposal object at curernt id
        uint _currentId=currentId;//current id on a new variable for future use
        currentId++;//increases the current ID
        proposals[_currentId].newAddress=newTransferManager;//address for the new contract
        proposals[_currentId].contractID=1;//contract type is transfer(ID=1)
        proposals[_currentId].votes[msg.sender]=myVote;//stores I have voted with my tokens
        proposals[_currentId].total=myVote;//starting votes is my balance
        if(myVote>((variablesManager.totalSupply()/2)+1)){//if my balance is more than 50%+1 of supply
            proposals[_currentId].approved=true;//the proposal is approved
            coreManager.setTransferManager(newTransferManager);//new transfer is updated on the core
            variablesManager.setTransferManager(newTransferManager);//new transfer is updated on variable manager
        }else{
            proposals[_currentId].approved=false; //if I have less than enough, proposal is not yet approved
        }
        thisProposalId=_currentId; //returns the ID of the proposal
    }
    
    function variableChangeProposal(address newVariableManager) public{
        
    }
    
    //for checking the status of a proposal
    function getChangeProposal(uint proposalId) public view returns(address newAddressProposed, string memory contractType, uint votesFor, bool isApproved){
        changeProposal memory _changeProposal = proposals[proposalId];//stores in memory the object of the proposal
        string memory contractId; //string for telling the contract type of the proposal
        if (_changeProposal.contractID==1){//if id is 1 (transfer)
            contractId="transfer";//remembers it is a transfer contract
        } else if(_changeProposal.contractID==2){//if id is 2(variable)
            contractId="variable";//remembers it is a variable contract
        }
        newAddressProposed=_changeProposal.newAddress; //returns the proposed(new) contract address
        contractType=contractId;//returns the name of the type of the contract (transfer or variable)
        votesFor=_changeProposal.total; //returns total of votes for this proposal
        isApproved=_changeProposal.approved; //returns the status (approved or not)
    }
    
    //for voting on a proposal
    function approveChange(uint proposalId) public{
        proposals[proposalId].votes[msg.sender]=variablesManager.balanceOf(msg.sender);//records my vote value
        proposals[proposalId].total+=variablesManager.balanceOf(msg.sender);//adds my votes to the total
        if(proposals[proposalId].total>((variablesManager.totalSupply()/2)+1)){//is total is more than 50%+1
            proposals[proposalId].approved=true;//records the change is approved
            coreManager.setTransferManager(proposals[proposalId].newAddress); //changes the manager on the core
            variablesManager.setTransferManager(proposals[proposalId].newAddress);//changes the manager on the variable manager
        }
    }
}
