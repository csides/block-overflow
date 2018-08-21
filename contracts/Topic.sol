pragma solidity ^0.4.24;

import ForumManager from "./ForumManager.sol"
import Question from "./Question.sol"
import Answer from "./Answer.sol"


contract Topic {
    address public owner;
    mapping(address => bool) public admins;

    address[] public questions;
    address[] public urgentQuestions;
    address[] public contestedQuestions;

    
    mapping(address => bytes24) questionNames;

    modifier onlyOwner() {
        if (msg.sender == owner) _;
    }

    modifier onlyAdmin() {
        if (admins[msg.sender]) _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function makeQuestion() public payable {

    }

    function deleteQuestion(address deletedQuestion) public {

    }

    function addAdmin(address newAdmin) {

    }

    function removeAdmin(address adminToRemove) { 

    }
}