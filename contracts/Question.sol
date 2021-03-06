pragma solidity ^0.4.24;

import {Topic} from "./Topic.sol";
import {Answer} from "./Answer.sol";

/*
    @title Topic 
    @dev A question, which invites responses. The value stored within the question is later awarded to the accepted answer
    @dev Not all functions are commented
*/
contract Question {
    address public owner;
    address public topic;
    address public forum;
    bool public halted;

    address[] public answers;
    mapping(address => uint256) public answerIndex;

    uint256 public initialValue;
    uint256 public addedValue;
    uint256 public answerValue;

    string public title;
    string public description;

    uint256 public createdAt;
    uint256 public closedAt;
    bool public isUrgent;

    bool public answerContested;
    address public acceptedAnswerOwner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the question owner may call this");
        _;
    }

    /**
      * @dev payable function intended to create a new question
      * @param _forum Deprecated as of this project
      * @param _topic Address of the controlling topic for this question
      * @param _title The title of the question (short)
      * @param _description A longer description of the details of the question
    */
    constructor(address _forum, address _topic, string _title, string _description) 
    public 
    payable 
    {
        owner = msg.sender;
        forum = _forum;
        topic = _topic;
        title = _title;
        description = _description;
        initialValue = msg.value;
        addedValue = 0;
        answerValue = 0;
    }

    /**
      * @dev payable function to construct an answer for this question
      * @param _title The title of the answer
      * @param _description The main body of the answer
    */
    function makeAnswer(string _title, string _description) public payable {
        require(msg.value >= (initialValue/10), "Not enough value sent to answer question.");
        address newAnswer = (new Answer).value(msg.value)(_title, _description, owner, this);
        answerIndex[newAnswer] = answers.push(newAnswer) - 1;
    }

    function acceptAnswer(address acceptedAnswer) public onlyOwner {
        Answer(acceptedAnswer).accept();
        acceptedAnswerOwner = Answer(acceptedAnswer).owner();
    }

    function listAnswers() public view returns(address[]) {
        return answers;
    }

    function rejectAnswer(address rejectedAnswer) public onlyOwner {
        Answer(rejectedAnswer).reject();
    }

    function upvoteQuestion() public payable {
        addedValue += msg.value;
    }

    // Incomplete function to make a question urgent for a price such that it gets answered sooner
    // function makeUrget() public payable {
    //     require(msg.value >= ForumManager(forum).urgentPrice(), "Not enough value sent to make question urgent");
    //     require(!isUrgent, "This question is already urgent");
    //     isUrgent = true;
    //     Topic(topic).addUrgent();
    // }

    function getTitle() public view returns(string) {
        return title;
    }

    function getDescription() public view returns(string) {
        return description;
    }

    function getValue() public view returns(uint256) {
        return initialValue + addedValue;
    }

    // Payable method to recieve transfered funds from answer
    // TODO: Implement control over who can call this
    function transferAnswerFunds() public payable returns(bool){
        answerValue += msg.value;
        return true;
    }

    // Method to initial collection of answer funds
    // TODO: Implement control over who can call this
    function collectAnswerFunds(address answerToCollect) public {
        Answer(answerToCollect).withdrawValue();
    }
}