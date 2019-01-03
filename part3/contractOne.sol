pragma solidity ^0.5.0;

//parent contract
contract one{
    uint internal myVariable;//non initiated variable
//I will talk about the internal vs private vs public a bit later in this tutorial
}

//child contract
contract two is one{
    function sumToOne() public{
        myVariable++; //when you call this function the myVariable from the child
//increases by one
    }
    
    function getOne() public view returns(uint){
        return myVariable;//when you call this function you get the value
//of the variable from this child
    }
}

//third child, works exactly like the previous child
//but has it's own variables dettached from the other contracts
contract three is one{
    function sumToTwo() public{
        myVariable++;
    }
    function getTwo() public view returns(uint){
        return myVariable;
    }
}
