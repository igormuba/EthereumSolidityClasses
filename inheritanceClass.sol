pragma solidity ^0.5.0;

contract parent{
    uint parentNumber=1;
    function getNumber() public view returns (uint){
        return parentNumber;
    }
}

contract kid is parent{
    uint kidNumber=1;
    function getNumber() public view returns (uint){
        return kidNumber;
    }
}

contract test is parent, kid{
    function callNumber() public view returns (uint){
        getNumber();
    }
}
