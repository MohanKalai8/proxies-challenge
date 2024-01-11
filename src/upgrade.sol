// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Proxy} from "@openzeppelin/contracts/proxy/Proxy.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract upgrade is Proxy,Ownable{
    // bytes32(uint(keccak256("eip1967.proxy.implementation"))-1)
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    uint256 number;

    constructor() Ownable(msg.sender){}

    function setImplementation(address newImplementation) public {
        assembly {
            sstore(_IMPLEMENTATION_SLOT,newImplementation)
        }
    }

    function _implementation() internal view override returns (address implementationAddress){
        assembly{
            implementationAddress := sload(_IMPLEMENTATION_SLOT)
        }
    }

    function dataToTransact(uint256 one,uint256 two) public pure returns(bytes memory data) {
        data = abi.encodeWithSignature("setNumber(uint256,uint256)",one,two);
        return data;
    }

    function getNumber() public view returns(uint256){
        return number;
    }

    receive() external payable{}

}

// This is our first implementation
contract implementationA{
    uint256 number;

    function setNumber(uint256 value1,uint256 value2) public {
        number = number + value1;
    }

}

// This is the second implementation
contract implementationB {
    struct Str {
        uint256 myIntA; // first slot
        uint256 myIntB; // second slot
    }

    Str public myStruct;

    function setNumber(uint256 value1,uint256 value2) public {
        myStruct.myIntA = myStruct.myIntA + value1 + value2;
        myStruct.myIntB = myStruct.myIntB + value1 + value2;
    }

}