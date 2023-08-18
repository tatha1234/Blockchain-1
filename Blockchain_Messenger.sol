//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


contract smart_contract {
    string public myString="Hi, What are you doing?";
    function Update_our_string(string memory _updated_string) public payable  {
        if (msg.value!=1 ether) {
            myString=_updated_string;
            payable(msg.sender).transfer(msg.value); 
        } 
       
    } 
}
