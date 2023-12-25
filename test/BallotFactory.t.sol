// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "forge-std/Test.sol";
import "../src/BallotFactory.sol";
import "../src/Ballot.sol";

contract BallotFactoryTest is Test {
    BallotFactory factory;

    function setUp() public {
        factory = new BallotFactory();
    }

    function testCreateBallot() public {
        bytes32 dummyRoot = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
        factory.createBallot(dummyRoot);

        assertEq(factory.getNumberOfBallots(), 1, "Should have created one ballot");
    }

    function testGetBallot() public {
        bytes32 dummyRoot = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
        factory.createBallot(dummyRoot);

        Ballot createdBallot = factory.getBallot(0);
        assertTrue(address(createdBallot) != address(0), "Ballot address should not be zero");
    }
}
