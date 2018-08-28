pragma solidity ^0.4.24;

import {Question} from "./Question.sol";

/*
    @title Answer 
    @dev An answer for a question, which can then be accepted or rejected, and stores and transfers value
    @dev Not all functions are commented
*/
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
    
    /*
      * @dev a payable function used to create an answer
      * @dev migrate away from using tx.origin
      * @param _title
      * @param _description
      * @param _questionOwner the address of the owner of the question
      * @param _parentQuesion the address of the parent question contract  
    */
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

    /*
      * @dev accept this answer (only called from parent question)
    */
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

    /*
      * @dev reject this answer (only called from parent question)
    */
    function reject() public onlyQuestion {
        require(!rejected, "Question cannot already be rejected");
        rejected = true;
        accepted = false;
        rejectedAt = now;
    }

    function isRejected() public view returns(bool) {
        return rejected;
    }

    /*
      * @dev add aditional value to this answer (anyone may call)
    */
    function upvoteAnswer() public payable {
        upvotedValue += msg.value;
    }

    /*
      * @dev contest the rejection of this question (only from the quesiton owner)
      * @dev the question must first be rejected
    */
    function contestRejection() public onlyOwner {
        require(rejected, "Question must be rejected");
        contested = true;
        contestedAt = now;
    }

    function isContested() public view returns(bool) {
        return contested;
    }

    /*
      * @dev Withdraw the value from this question, eventually getting to topic level (only called form parent question)
    */
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