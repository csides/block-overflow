# BlockOverflow
    BlockOverflow is inteded to be an open forum for discussion of CS related topics and questions.  
    The forum was deisgned to be similar to StackOverflow, with the exception that questions, answers, and upvotes have value.  
    The premise is that more questions will be answered faster and more thoroughly if people are rewarded for their time.  

## Project Overview
    Sadly I ran out of time to finish the project before the course deadline. There were many bugs that took a long time to track down and fix, and
    the testing suite took much longer than expected. The ForumManager contract was forsaken, and the project scope was significantly limited.

    The project turned into: a topic which has lists of questions. Questions have a minimum value when they are created, and the value is rewarded to the
    person who ends up giving the correct answer (or the best correct answer). Later on, if people upvote the question or answer (small charge for each upvote)
    these additional funds will go to the owner of the question or answer. There were more planned features, such as making a question 'urgent' for a higher price,
    significant admin abilities and control, and more advanced monetary policies, but these had to be cut.

## Installation
Clone the repo from github.  
Navigate into the repo directory (block_overflow).  

// I have found this takes away, and spits many many warning messages  
npm install

### To compile and deploy the contracts
#### In one terminal window
ganache-cli  

#### In another
truffle compile  
truffle migrate

### To launch the front end node server (Not complete at all)
npm run start

Visit: 
http://localhost:3000/
To view the website.

### To run the testing suite
truffle develop  
test

