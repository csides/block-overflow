import React, { Component } from 'react'
import QuestionContract from '../build/contracts/Question.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      web3: null,
      contractTitle: null,
      contractDesc: null,
      accounts: null
    }
  }

  componentWillMount() {
    // Get network provider and Web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })
      // Instantiate contract once Web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding Web3.')
    })
  }

  instantiateContract() {
    const contract = require('truffle-contract')
    const question = contract(QuestionContract)
    question.setProvider(this.state.web3.currentProvider)

    // Declaring this for later so we can chain functions on SimpleStorage.
    var questionInst

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      this.setState({accounts});
      question.deployed().then((instance) => {
        questionInst = instance
      }).then(() => {
        questionInst.getTitle.call(accounts[0]).then( (res) => this.setState({contractTitle: res}));
        questionInst.getDescription.call(accounts[0]).then( (res) => this.setState({contractDesc: res}));
      })
    })
  }

  render() {
    console.log(this.state)
    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Block Overflow</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>Welcome to the Forum!</h1>
              <p>Browse the questions as needed, and leave a new one if you dont find what you need!</p>
              <p>Alterantively, earn some extra ether by helping others out!</p>
              <h2>Smart Contract Connection Example</h2>
              <p>The front end of this application was left to the end, which resulted in it not being done at all</p>
              <p>This is simply an example of a deployed contract parsed in by Web3.</p>
              <p>The question title is: {this.state.contractTitle}</p>
              <p>The question description is: {this.state.contractDesc}</p>
              <p>Current account: {this.state.accounts && this.state.accounts[0]}</p>
            </div>
          </div>
        </main>
      </div>
    );
  }
}

export default App
