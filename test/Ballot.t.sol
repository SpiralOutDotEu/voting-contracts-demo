// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Ballot.sol";

contract BallotTest is Test {
    Ballot ballot;

    function setUp() public {
        bytes32 dummyRoot = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
        ballot = new Ballot(dummyRoot);
    }

    function testVote() public {
        bytes32[] memory dummyProof = new bytes32[](1);
        dummyProof[0] = bytes32(bytes("0x123"));

        ballot.vote(true, dummyProof);
        (uint yesVotes, uint noVotes) = ballot.getResults();
        
        assertEq(yesVotes, 1, "Yes votes should be 1");
        assertEq(noVotes, 0, "No votes should be 0");
    }

    function testDoubleVoting() public {
        bytes32[] memory dummyProof = new bytes32[](1);
        dummyProof[0] = bytes32(bytes("[0xc0ffee, 0xbeef]"));

        ballot.vote(true, dummyProof);
        vm.expectRevert("Already voted");
        ballot.vote(true, dummyProof);
    }
}
