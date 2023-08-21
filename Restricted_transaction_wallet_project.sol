//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


contract RestrictedTransactionContract {
    address public owner;
    mapping(address => bool) public allowedAddresses;
    uint public maxTransactionAmount;

    constructor(uint _maxTransactionAmount) {
        owner = msg.sender;
        maxTransactionAmount = _maxTransactionAmount;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyAllowed() {
        require(msg.sender == owner || allowedAddresses[msg.sender], "Not authorized to make transactions");
        _;
    }

    

    function setAllowedAddress(address _addr, bool _allowed) public onlyOwner {
        allowedAddresses[_addr] = _allowed;
    }

    function setMaxTransactionAmount(uint _amount) public onlyOwner {
        maxTransactionAmount = _amount;
    }

    function makeTransaction(address payable _to, uint _amount) public payable  onlyAllowed {
        require(_amount <= maxTransactionAmount, "Transaction amount exceeds maximum");
        require(address(this).balance >= _amount, "Insufficient balance");
        _to.transfer(_amount);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    receive() external payable {
        // Accept payments
    }

}
