// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract Ballot {
    bytes32 public merkleRoot;
    mapping(address => bool) public hasVoted;
    uint public yesVotes;
    uint public noVotes;

    constructor(bytes32 root) {
        merkleRoot = root;
    }

    function vote(bool voteYes, bytes32[] calldata proof) public {
        require(!hasVoted[msg.sender], "Already voted");
        require(isValidVoter(msg.sender, proof), "Not a valid voter");

        hasVoted[msg.sender] = true;
        if (voteYes) {
            yesVotes++;
        } else {
            noVotes++;
        }
    }

    function isValidVoter(address voter, bytes32[] memory proof) public view returns (bool) {
        // TODO: add implementation
        return true; 
    }

    function getResults() public view returns (uint yes, uint no) {
        return (yesVotes, noVotes);
    }
}