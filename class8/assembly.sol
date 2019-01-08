pragma solidity ^0.5.0;

contract solidityAssembly{
    
    function assemblyLoop() public pure returns (uint _x){
        assembly {
            for {let counter:= 0} lt(counter, 10) {counter := add(counter,1)}{
                _x := add(_x,1)
            }
        }
    }
    
    function solidityLoop() public pure returns (uint _x){
        for (int count=0; count<10;count++){
            _x++;
        }
    }
    
    function switchCase(uint _x) public pure returns (uint _y){
        assembly{
            switch _x
            case 1{
                _y:=2
            }
            case 2{
                _y:=1
            }
            default{
                _y:=0
            }
        }
    }
    
    function ifElseSwitchCase(uint _x) public pure returns (uint _y){
        if (_x==1){
        	_y==2;
        }
        else if (_x==2){
            _y == 1;
        }
        else{
            _y==0;
        }
    }
}
