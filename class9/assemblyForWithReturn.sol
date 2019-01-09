pragma solidity ^0.5.0;

contract solidityAssembly{
    
    function assemblyLoop(uint _number) public pure returns (uint){
        assembly {
            let _pointer:=add(msize(), 1)
            let _x:=_number
            for {let counter:= 0} lt(counter, 10) {counter := add(counter,1)}{
                _x := add(_x, 1)
            }
            mstore(_pointer, _x)
            return(_pointer, 0x20)
        }
    }
}
