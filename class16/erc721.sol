pragma solidity ^0.5.0;

import "browser/ERC165.sol";

contract uniqueToken is ERC165{
    function supportsInterface(bytes4 interfaceID) external view returns (bool){//function from the ERC165 interface
        if (interfaceID==0x80ac58cd){//checks if the caller wants an ERC721 token
            return true;//returns true if both agree it is ERC721
        }
    }
    mapping(address => mapping (address => uint256)) allowed; //allowed addresses for a token owner
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId); //transfer event
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId); //approval event
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved); //approval for all event
    uint private currentId=0; //curent token ID to automatically assign to tokens
    struct ourToken{ //skeleton of token
        uint id; //atomatically assigned ir
        string name; //given name of token
        uint value; //given token price
        address owner; //token owner
    }
    ourToken[] tokens; //stored all created tokens
    mapping(uint => address) public ownership; //maps owner of token
    mapping(address=>uint) public balance; //eth balance hosted in the contract of addresses
    mapping(address=>uint) public uniqueTokens; //how many tokens an address has
    mapping(address=>mapping(address=>bool)) public allowedAddresses; //allowed addresses to manage token balance of an address
    
    function approve(address _approved, uint256 _tokenId) external payable{ //changes token ownership
        require(msg.sender == ownership[_tokenId]); //only token owner can do this
        emit Approval(ownership[_tokenId], _approved, _tokenId); //emits event of ownership change
        uniqueTokens[ownership[_tokenId]]-=1;//reduces 1 token from former owner
        uniqueTokens[ownership[_approved]]+=1;//records receiver has one new token
        ownership[_tokenId]=_approved; //changes ownership of token
        tokens[_tokenId].owner=_approved; //changes owner in token struct
    }
    
    
    function getApproved(uint256 _tokenId) external view returns (address){ //returns who owns a given token
        return ownership[_tokenId]; //returns token owner
    }
    
    function isApprovedForAll(address _owner, address _operator) external view returns (bool){
        return allowedAddresses[_owner][_operator]; //checks if _operator chan manage _owner tokens
    }
    
    function setApprovalForAll(address _operator, bool _approved) external{ //allows _operator to manage msg.sender tokens
        allowedAddresses[msg.sender][_operator]= _approved; //adds _operator to the allowedAddresses mapping
        emit ApprovalForAll(msg.sender, _operator, _approved); //alerts the network of the change
    }
    
    function balanceOf(address _owner) external view returns (uint256){
        return uniqueTokens[_owner]; //how many tokens _owner has
    }
    
    function tokenValue(uint _id) public view returns (uint){
        return tokens[_id].value; //sees price of token _id
    }
    
    function ownerOf(uint _id) public view returns(address){
        return ownership[_id]; //sees owner of token _id
    }
    
    function createToken(string memory _name, uint value) public{ //function to create a new token
        tokens.push(ourToken(currentId, _name, value, msg.sender)); //pushes token to token list storage
        ownership[currentId]=msg.sender; //caller is the owner
        uniqueTokens[msg.sender]+=1; //records the msg.sender has one new token
        emit Transfer(msg.sender, msg.sender, currentId);//alerts the network of new token created
        currentId++; //updates the current currentId
        
    }
    
    function buyToken(uint _id) payable public{ //buys a token
        require(msg.value>=tokens[_id].value);//requires paid value is equal or bigger than asked price
        emit Transfer(tokens[_id].owner, msg.sender, _id);//alerts network of change of owner
        balance[tokens[_id].owner]+=msg.value;//adds credit for seller to be able to withdraw later
        uniqueTokens[msg.sender]+=1;//records buyer has one new token
        uniqueTokens[tokens[_id].owner]-=1;//records seller has one less token
        tokens[_id].owner = msg.sender;//changes owner of token in struct
        ownership[_id] = msg.sender;//records new ownership of token
    }
    
    function changeValue(uint _id, uint newValue) public{ //change price of token
        require(ownership[_id]==msg.sender||allowedAddresses[ownership[_id]][msg.sender]);//require that caller is owner or allowed to do this
        tokens[_id].value=newValue;//changes price of token _id
    }
    
    function safeTransferFrom(address _from, address _to, uint256 _id, bytes calldata data) external payable{//transfer _from _to
        if (msg.sender==tokens[_id].owner||allowedAddresses[ownership[_id]][msg.sender]){//checks of caller is owner or allowed
            emit Transfer(_from, _to, _id); //alerts the network
            uniqueTokens[_to]+=1; //adds one token to _to
            uniqueTokens[tokens[_id].owner]-=1; //reduces one token from previous owner or from _from
            tokens[_id].owner = msg.sender; //changes the owner on token struct
            ownership[_id] = msg.sender; //updates ownership
        }else{ //in case caller is a buyer
            require(msg.value>=tokens[_id].value);//paid value equals or greater than asked price
            emit Transfer(_from, _to, _id); //alerts the network
            balance[tokens[_id].owner]+=msg.value; //adds the credit balance for withdrawal later for the seller
            uniqueTokens[_to]+=1; //adds token to _to
            uniqueTokens[tokens[_id].owner]-=1;//reduces token from _from
            tokens[_id].owner = msg.sender; //changes owner of the token
            ownership[_id] = msg.sender; //updates ownership
        }
    }
    
    //similar function to above
        function safeTransferFrom(address _from, address _to, uint256 _id) external payable{
        if (msg.sender==tokens[_id].owner||allowedAddresses[ownership[_id]][msg.sender]){
            emit Transfer(_from, _to, _id);
            uniqueTokens[_to]+=1;
            uniqueTokens[tokens[_id].owner]-=1;
            tokens[_id].owner = msg.sender;
            ownership[_id] = msg.sender;
        }else{
            require(msg.value>=tokens[_id].value);
            emit Transfer(_from, _to, _id);
            balance[tokens[_id].owner]+=msg.value;
            uniqueTokens[_to]+=1;
            uniqueTokens[tokens[_id].owner]-=1;
            tokens[_id].owner = msg.sender;
            ownership[_id] = msg.sender;
        }
    }
    
    //similar function to above
        function transferFrom(address _from, address _to, uint256 _id) external payable{
        if (msg.sender==tokens[_id].owner||allowedAddresses[ownership[_id]][msg.sender]){
            emit Transfer(_from, _to, _id);
            uniqueTokens[_to]+=1;
            uniqueTokens[tokens[_id].owner]-=1;
            tokens[_id].owner = msg.sender;
            ownership[_id] = msg.sender;
        }else{
            require(msg.value>=tokens[_id].value);
            emit Transfer(_from, _to, _id);
            balance[tokens[_id].owner]+=msg.value;
            uniqueTokens[_to]+=1;
            uniqueTokens[tokens[_id].owner]-=1;
            tokens[_id].owner = msg.sender;
            ownership[_id] = msg.sender;
        }
    }
    

    function myBalance() public view returns (uint){
        return balance[msg.sender]; //gets my credit ETH balance on the contract
    }
    
    function withdraw() public{//withdrawals from my credit on contract
        uint toSend = balance[msg.sender]; 
	    balance[msg.sender]=0;//cleans the balance before to avoid exploits
        msg.sender.transfer(toSend); //transfer the credit
    }
    
}
