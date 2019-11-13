pragma solidity >=0.4.21 <0.6.0;

contract CrappToken{
    uint256 public totalSupply;

    constructor(uint256 _initalSupply) public {
        totalSupply = _initalSupply;
    }
}