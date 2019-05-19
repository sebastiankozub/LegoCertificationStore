import React, { Component } from "react"; 
import LegoCertificationStoreContract from "./contracts/LegoCertificationStore.json"; 
import getWeb3 from "./utils/getWeb3"; 
 
import "./App.css"; 
 
class App extends Component { 
  state = { storageValue: 0, web3: null, accounts: null, contract: null, responseArray: [0] }; 

  componentDidMount = async () => { 
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = LegoCertificationStoreContract.networks[networkId];
      const instance = new web3.eth.Contract(
        LegoCertificationStoreContract.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance}, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { accounts, contract } = this.state;

    // count gas price and amount - now hard coded
    const response1 = await contract.methods.getCertificatesCount().call();
    const response2 = await contract.methods.createNewCertificate("11111111","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg",["gdsfgdsfg"],["gdsfgdsfg","11111111111"]).send({from:accounts[0],gasPrice : this.state.web3.utils.toWei("5", "gwei"), gas : this.state.web3.utils.toWei("0.0000000000005", "ether")});
    const response3 = await contract.methods.createNewCertificate("22222222","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg",["gdsfgdsfg"],["gdsf3333422222","2222222"]).send({from:accounts[0], gasPrice: this.state.web3.utils.toWei("5", "gwei"), gas : this.state.web3.utils.toWei("0.0000000000005", "ether")});
    const response4 = await contract.methods.createNewCertificate("33333333","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg",["gdsfgdsfg"],["gdsf3333","23333333"]).send({from:accounts[0], gasPrice: this.state.web3.utils.toWei("5", "gwei"),  gas : this.state.web3.utils.toWei("0.0000000000005", "ether")});
    const response5 = await contract.methods.getCertificatesCount().call();

    // let txHash1 = response1.transactionHash1;
    // let txHash2 = response2.transactionHash2;
    // let txHash3 = response3.transactionHash3;
    // let txHash4 = response4.transactionHash4;
    // let txHash5 = response5.transactionHash5;

    // console.log(response1);
    // console.log(response2);
    // console.log(response3);
    // console.log(response4);
    // console.log(response5);

    var tempArray = [response1, response2.cumulativeGasUsed, response3.cumulativeGasUsed, response4.cumulativeGasUsed, response5];
    this.setState({ responseArray: tempArray});
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Good to Go! Go! Go!</h1>
        <p>Your Truffle Box is installed and ready.</p>
        <h2>Smart Contract Example</h2>
        <p>
          Few methods to test cooperation with MetaMask, Ganache, lite-server and few other tools...
        </p>
        <div>getCertificatesCount response1 value is: {this.state.responseArray[0]}</div>
        <div>createNewCertificate response2 value is: {this.state.responseArray[1]}</div>
        <div>createNewCertificate response3 value is: {this.state.responseArray[2]}</div>
        <div>createNewCertificate response4 value is: {this.state.responseArray[3]}</div>
        <div>getCertificatesCount response5 value is: {this.state.responseArray[4]}</div>
      </div>
    );
  };
}

export default App;

