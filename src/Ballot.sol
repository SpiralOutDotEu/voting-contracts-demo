// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

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
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(voter))));
        require(MerkleProof.verify(proof, merkleRoot, leaf), "Invalid proof");
        return true; 
    }

    function getResults() public view returns (uint yes, uint no) {
        return (yesVotes, noVotes);
    }
}