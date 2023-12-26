// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Ballot {
    string public ballotText;
    bytes32 public merkleRoot;
    mapping(address => bool) public hasVoted;
    uint256 public yesVotes;
    uint256 public noVotes;

    constructor(bytes32 root, string memory text) {
        merkleRoot = root;
        ballotText = text;
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

    function getResults() public view returns (uint256 yes, uint256 no) {
        return (yesVotes, noVotes);
    }
}
