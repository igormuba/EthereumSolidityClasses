pragma solidity ^0.5.0;

contract assemblyReturn{
    function storeAccess(uint number) public returns (uint){
        assembly{
            let _pointer:=add(msize(), 1)
            mstore(_pointer, number)
            return(_pointer, 0x20)
        }
    }
}
