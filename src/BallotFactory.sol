// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ballot.sol";

contract BallotFactory is Ownable {
    Ballot[] public ballots;

    constructor() Ownable(msg.sender) {}

    event BallotCreated(address ballotAddress);

    function createBallot(bytes32 root, string memory text) public onlyOwner {
        Ballot newBallot = new Ballot(root, text);
        ballots.push(newBallot);
        emit BallotCreated(address(newBallot));
    }

    function getBallot(uint256 index) public view returns (Ballot) {
        require(index < ballots.length, "Invalid index");
        return ballots[index];
    }

    function getNumberOfBallots() public view returns (uint256) {
        return ballots.length;
    }
}
