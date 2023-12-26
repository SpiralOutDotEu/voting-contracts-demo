// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Ballot.sol";

contract BallotTest is Test {
    Ballot ballot;
    string ballotText = "Test Ballot Text";
    // Sample Merkle Setup created with Open Zeppelin's Merkle implementation
    bytes32 root = 0x8bc017d1c1088a49d53256d47c70b0ee1f8c9ace53fc462ca45e6dcbc87f1fc2;

    // Addresses and their proofs
    address addr1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    bytes32[] proof1 = [
        bytes32(0x59856afbe8900ffcd32b8de545b9b5c0128ecda7289ff898b2ea8dc62b3f9a07),
        0xcaf0de3438122286ae0e65e28710cfc2e4eb37b9ed93dbaf12a49d465387383c
    ];

    address addr2 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    bytes32[] proof2 = [
        bytes32(0x24da68c5697e2b39240db86159eb0aea630eef50919653bc16409e95a183b6c6),
        0xcaf0de3438122286ae0e65e28710cfc2e4eb37b9ed93dbaf12a49d465387383c
    ];

    address addr3 = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    bytes32[] proof3 = [bytes32(0x85c99f9ed408529a8e32d19f1606c0783273722f7a42ae71ef5f7345b0e62870)];

    address invalidAddr = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
    bytes32[] stolenProof = proof1;
    // end of Sample Merkle Setup

    function setUp() public {
        vm.deal(addr1, 1 ether);
        vm.deal(addr2, 1 ether);
        vm.deal(addr3, 1 ether);
        vm.deal(invalidAddr, 1 ether);
        ballot = new Ballot(root, ballotText);
    }

    function testBallotText() public {
        assertEq(ballot.ballotText(), ballotText, "Ballot text should be correctly set");
    }

    function testValidVote() public {
        vm.prank(addr1);
        ballot.vote(true, proof1);

        vm.prank(addr2);
        ballot.vote(false, proof2);

        vm.prank(addr3);
        ballot.vote(true, proof3);

        (uint256 yesVotes, uint256 noVotes) = ballot.getResults();
        assertEq(yesVotes, 2, "Yes votes should be 2");
        assertEq(noVotes, 1, "No votes should be 1");
    }

    function testInvalidVoter() public {
        vm.prank(invalidAddr);
        vm.expectRevert("Invalid proof");
        ballot.vote(true, stolenProof);
    }

    function testDoubleVoting() public {
        vm.prank(addr1);
        ballot.vote(true, proof1);

        vm.prank(addr1);
        vm.expectRevert("Already voted");
        ballot.vote(true, proof1);
    }
}
