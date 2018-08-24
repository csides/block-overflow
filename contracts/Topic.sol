pragma solidity ^0.4.24;

import {ForumManager} from "./ForumManager.sol";
import {Question} from "./Question.sol";
import {Answer} from "./Answer.sol";


contract Topic {
    address public owner;
    address public forum;
    bool public halted;

    mapping(address => bool) public admins;

    address[] public questions;
    address[] public urgentQuestions;
    address[] public contestedQuestions;

    mapping(address => bytes24) questionNames;
    mapping(address => uint256) questionIndex;

    modifier onlyOwner() {
        if (msg.sender == owner) _;
    }

    modifier onlyAdmin() {
        if (admins[msg.sender]) _;
    }

    constructor(address _forum) public payable {
        owner = msg.sender;
        admins[owner] = true;
        forum = _forum;
    }

    function makeQuestion(bytes24 name, string title, string description) public payable {
        require(msg.value >= (ForumManager)(forum).topicPrice(), "Not enough value sent to create a question");
        address newQuestion = (new Question).value(msg.value)(forum, this, title, description);
        questionIndex[newQuestion] = questions.push(newQuestion);
        questionNames[newQuestion] = name;
    }

    function deleteQuestion(address deletedQuestion) public {

    }

    function addAdmin(address newAdmin) public onlyOwner {

    }

    function removeAdmin(address adminToRemove) public onlyOwner { 

    }

    function haltTopic() public onlyAdmin {
        halted = true;
    }

    function unhaltTopic() public onlyAdmin {

    }
}