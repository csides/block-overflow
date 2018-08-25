pragma solidity ^0.4.24;

import {ForumManager} from "./ForumManager.sol";
import {Topic} from "./Topic.sol";
import {Answer} from "./Answer.sol";

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

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the question owner may call this");
        _;
    }

    constructor(address _forum, address _topic, string _title, string _description) 
    public 
    payable 
    {
        forum = _forum;
        topic = _topic;
        title = _title;
        description = _description;
        initialValue = msg.value;
        addedValue = 0;
        answerValue = 0;
    }

    function makeAnswer(string _title, string _description) public payable {
        require(msg.value >= (initialValue/10), "Not enough value sent to answer question.");
        address newAnswer = (new Answer).value(msg.value)(_title, _description, owner, this);
        answerIndex[newAnswer] = answers.push(newAnswer) - 1;
    }

    function acceptAnswer(address acceptedAnswer) public onlyOwner {
        Answer(acceptedAnswer).accept();
    }

    function rejectAnswer(address rejectedAnswer) public onlyOwner {
        Answer(rejectedAnswer).reject();
    }

    function upvoteQuestion() public payable {
        addedValue += msg.value;
    }

    function makeUrget() public payable {
        require(msg.value >= ForumManager(forum).urgentPrice(), "Not enough value sent to make question urgent");
        require(!isUrgent, "This question is already urgent");
        isUrgent = true;
        Topic(topic).addUrgent();
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

    function transferAnswerFunds() public payable returns(bool){
        answerValue += msg.value;
        return true;
    }

    function collectAnswerFunds(address answerToCollect) public {
        Answer(answerToCollect).withdrawValue();
    }
}