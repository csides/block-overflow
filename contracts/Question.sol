pragma solidity ^0.4.24;

import ForumManager from "./ForumManager.sol"
import Topic from "./Topic.sol"
import Answer from "./Answer.sol"

contract Question {
    address public owner;
    address[] public answers;

    address public topic;
    address public forum;

    uint256 public initialValue;
    uint256 public addedValue;

    string public title;
    string public description;

    uint256 public createdAt;
    uint256 public closedAt;
    bool public isUrgent;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function makeAnswer() public payable {

    }

    function acceptAnswer(address acceptedAnswer) public onlyOwner {

    }

    function rejectAnswer(address rejectedAnswer) public onlyOwner {

    }

    function upvoteQuestion() public payable {

    }

    function makeUrget() public payable {

    }

    function getTitle() public view returns(string) {
        return title;
    }

    function getDescription() public view returns(string) {
        return description;
    }

    function getValue() public view returns(uint256) {
        return initialValue + addedValue;
    }
}