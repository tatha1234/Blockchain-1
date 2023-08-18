//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

contract MappingsStruct {
     mapping(address => uint256) public value_of_address;
      

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function sendMoney() public payable {
    value_of_address[msg.sender]+=msg.value;
    
    }
     function withdraw(address payable _to, uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= value_of_address[msg.sender], "Insufficient balance");

        value_of_address[msg.sender] -= amount;
        _to.transfer(amount);
     }

    function withdrawAllMoney(address payable _to) public {
        uint balance=value_of_address[msg.sender];
        value_of_address[msg.sender]=0;
        _to.transfer(balance);
        


    }
}
