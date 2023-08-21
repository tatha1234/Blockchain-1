// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSignWallet {
    address public owner;
    mapping(address => bool) public guardians;
    address[] public initialGuardians; 
    uint public minGuardianApprovals;
    mapping(address => uint) public allowance;

    constructor(address[] memory _initialGuardians, uint _minGuardianApprovals) {
        require(_initialGuardians.length >= _minGuardianApprovals, "Initial guardians should be greater than or equal to min approvals");
       
        owner = msg.sender;
        for (uint i = 0; i < _initialGuardians.length; i++) {
            guardians[_initialGuardians[i]] = true;
        }
        minGuardianApprovals = _minGuardianApprovals;
        initialGuardians=_initialGuardians;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyGuardian() {
        require(guardians[msg.sender], "Only guardians can call this function");
        _;
    }

    function setAllowance(address _spender, uint _amount) public onlyOwner {
        allowance[_spender] = _amount;
    }

    function spend(address payable  _to, uint _amount) public payable  onlyGuardian {
        require(_amount <= allowance[_to], "Amount exceeds allowed limit");
        _to.transfer(_amount);
        allowance[_to] -= _amount;
        // Logic to transfer funds
    }

      function changeOwner(address _newOwner) public onlyGuardian {
        require(minGuardianApprovals >= 3, "Minimum guardian approvals should be 3 or more");
        
        uint approvalCount = 0; // Counting the current guardian's approval
        
        for (uint i = 0; i < initialGuardians.length; i++) {
            if (guardians[initialGuardians[i]] && initialGuardians[i] != msg.sender && initialGuardians[i] != _newOwner) {
                approvalCount++;
            }
            if (approvalCount >= minGuardianApprovals) {
                owner = _newOwner;
                break;
            }
        }
    }
    receive() external payable {
        // Accept incoming funds
    }
   
}
