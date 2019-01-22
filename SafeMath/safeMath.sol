pragma solidity ^0.5.0;

contract safeMath{
    
    function safeAdd(uint _a, uint _b) public pure returns(uint){
        uint c = _a+_b;
        require(c>=_a && c>=_b);
        return c;
    }
    
    function safeSub(uint _a, uint _b) public pure returns (uint){
        require(_b<=_a);
        return _a-_b;
    }
    
    function safeMul(uint _a, uint _b) public pure returns(uint){
        uint c = _a * _b;
        require(_a==0 || c/_a==_b);
        return c;
    }
    
    function safeDiv(uint _a, uint _b) public pure returns (uint) {
        require(_b > 0);
        uint c = _a / _b;
        require(_a == _b * c + _a % _b);
        return c;
    }
    
}
