pragma solidity ^0.4.24;

import {ForumManager} from "./ForumManager.sol";
import {Topic} from "./Topic.sol";
import {Question} from "./Question.sol";

contract Answer {
    address public owner;
    address public questionOwner;
    address public parentQuestion;

    bool public accepted;
    uint256 public acceptedAt;
    bool public rejected;
    uint256 public rejectedAt;
    bool public contested;
    uint256 public contestedAt;

    string public title;
    string public description;

    uint256 public createdAt;

    uint256 initialValue;
    uint256 upvotedValue;

    constructor(string _title, string _description, address _questionOwner, address _parentQuestion) public payable {
        title = _title;
        description = _description;
        owner = msg.sender;
        questionOwner = _questionOwner;
        parentQuestion = _parentQuestion;
        accepted = false;
        rejected = false;
        createdAt = now;
        initialValue = msg.value;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Can only be sent from the answer owner");
        _;
    }

    modifier onlyQuestion() {
        require(msg.sender == parentQuestion, "Can only be sent from the question contract");
        _;
    }

    modifier onlyQuestionOwner() {
        require(msg.sender == questionOwner, "Can only be sent from the question owner");
        _;  
    }

    function accept() public onlyQuestion {
        accepted = true;
        acceptedAt = now;
    }

    function reject() public onlyQuestion {
        rejected = true;
        rejectedAt = now;
    }

    function upvoteAnswer() public payable {
        upvotedValue += msg.value;
    }

    function contestRejection() public onlyOwner {
        contested = true;
        contestedAt = now;
    }

    function withdrawValue() public onlyQuestion {
        Question(parentQuestion).transferAnswerFunds.value(address(this).balance)();
    }

    function getTitle() public view returns(string) {
        return title;
    }

    function getDescription() public view returns(string) {
        return description;
    }

    function getValue() public view returns(uint256) {
        return initialValue + upvotedValue;
    }
}