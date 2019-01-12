pragma solidity ^0.5.0;

contract testContract{
    uint private _number;
    constructor(uint number) public{
        _number = number;
    }
//testContract.at("0xe7522f2A074ef5E8A907EfF5138A0575863d10A4").number
    function number() public view returns (uint){
        return _number;
    }

    function setNumber(uint newNumber) public{
        _number = newNumber;
    }
}