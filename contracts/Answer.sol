pragma solidity ^0.4.24;

import ForumManager from "./ForumManager.sol"
import Topic from "./Topic.sol"
import Question from "./Question.sol"

contract Answer {
    address public owner;
    address public questionOwner;
    address public parentQuestion;

    bool public accepted;
    bool public rejected;

    string public title;
    string public description;

    uint256 public createdAt;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function upvoteAnswer() public payable {
        
    }

    function contestRejection() public onlyOwner {

    }
}