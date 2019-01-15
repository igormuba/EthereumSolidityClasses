pragma solidity ^0.5.0;

import "browser/ERC165.sol";

contract uniqueToken is ERC165{
    function supportsInterface(bytes4 interfaceID) external view returns (bool){
        if (interfaceID==0x80ac58cd){
            return true;
        }
    }
    mapping(address => mapping (address => uint256)) allowed;
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    uint private currentId=0;
    struct ourToken{
        uint id;
        string name;
        uint value;
        address owner;
    }
    ourToken[] tokens;
    mapping(uint => address) public ownership;
    mapping(address=>uint) public balance;
    mapping(address=>uint) public uniqueTokens;
    
    function balanceOf(address _owner) external view returns (uint256){
        return uniqueTokens[_owner];
    }
    
    function tokenValue(uint _id) public view returns (uint){
        return tokens[_id].value;
    }
    
    function ownerOf(uint _id) public view returns(address){
        return ownership[_id];
    }
    
    function createToken(string memory _name, uint value) public{
        tokens.push(ourToken(currentId, _name, value, msg.sender));
        ownership[currentId]=msg.sender;
        uniqueTokens[msg.sender]+=1;
        currentId++;
    }
    
    function buyToken(uint _id) payable public{
        require(msg.value>=tokens[_id].value);
        balance[tokens[_id].owner]+=msg.value;
        uniqueTokens[msg.sender]+=1;
        uniqueTokens[tokens[_id].owner]-=1;
        tokens[_id].owner = msg.sender;
        ownership[_id] = msg.sender;
    }
    
    function changeValue(uint _id, uint newValue) public{
        require(ownership[_id]==msg.sender);
        tokens[_id].value=newValue;
    }
    
    function safeTransferFrom(address _from, address _to, uint256 _id, bytes calldata data) external payable{
        if (msg.sender==tokens[_id].owner){
            uniqueTokens[msg.sender]+=1;
            uniqueTokens[tokens[_id].owner]-=1;
            tokens[_id].owner = msg.sender;
            ownership[_id] = msg.sender;
        }else{
            require(msg.value>=tokens[_id].value);
            balance[tokens[_id].owner]+=msg.value;
            uniqueTokens[msg.sender]+=1;
            uniqueTokens[tokens[_id].owner]-=1;
            tokens[_id].owner = msg.sender;
            ownership[_id] = msg.sender;
        }
    }
    
        function safeTransferFrom(address _from, address _to, uint256 _id) external payable{
        if (msg.sender==tokens[_id].owner){
            uniqueTokens[msg.sender]+=1;
            uniqueTokens[tokens[_id].owner]-=1;
            tokens[_id].owner = msg.sender;
            ownership[_id] = msg.sender;
        }else{
            require(msg.value>=tokens[_id].value);
            balance[tokens[_id].owner]+=msg.value;
            uniqueTokens[msg.sender]+=1;
            uniqueTokens[tokens[_id].owner]-=1;
            tokens[_id].owner = msg.sender;
            ownership[_id] = msg.sender;
        }
    }
    
        function transferFrom(address _from, address _to, uint256 _id) external payable{
        if (msg.sender==tokens[_id].owner){
            uniqueTokens[msg.sender]+=1;
            uniqueTokens[tokens[_id].owner]-=1;
            tokens[_id].owner = msg.sender;
            ownership[_id] = msg.sender;
        }else{
            require(msg.value>=tokens[_id].value);
            balance[tokens[_id].owner]+=msg.value;
            uniqueTokens[msg.sender]+=1;
            uniqueTokens[tokens[_id].owner]-=1;
            tokens[_id].owner = msg.sender;
            ownership[_id] = msg.sender;
        }
    }
    

    function myBalance() public view returns (uint){
        return balance[msg.sender];
    }
    
    function withdraw() public{
        uint toSend = balance[msg.sender];
	    balance[msg.sender]=0;
        msg.sender.transfer(toSend);
    }
    
}
