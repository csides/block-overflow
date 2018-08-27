pragma solidity ^0.4.24;

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
        owner = tx.origin;
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
        require(!accepted, "Question cannot already be accepted");
        accepted = true;
        rejected = false;
        contested = false;
        acceptedAt = now;
    }

    function isAccepted() public view returns(bool) {
        return accepted;
    }

    function reject() public onlyQuestion {
        require(!rejected, "Question cannot already be rejected");
        rejected = true;
        accepted = false;
        rejectedAt = now;
    }

    function isRejected() public view returns(bool) {
        return rejected;
    }

    function upvoteAnswer() public payable {
        upvotedValue += msg.value;
    }

    function contestRejection() public onlyOwner {
        require(rejected, "Question must be rejected");
        contested = true;
        contestedAt = now;
    }

    function isContested() public view returns(bool) {
        return contested;
    }

    function withdrawValue() public onlyQuestion {
        require(accepted || rejected, "The question must be accepted or rejected");
        // require(acceptedAt / rejectedAt to be past certain time window);
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