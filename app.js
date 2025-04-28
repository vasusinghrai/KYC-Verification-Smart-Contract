// app.js
const contractAddress = "0x9e12C6B58b3141817AAC1Bf91aE257C98B928879";
const contractABI = [/* Replace with ABI JSON */];

let web3;
let contract;
let currentAccount;

window.addEventListener('load', async () => {
    if (window.ethereum) {
        web3 = new Web3(window.ethereum);
        await window.ethereum.request({ method: "eth_requestAccounts" });
        const accounts = await web3.eth.getAccounts();
        currentAccount = accounts[0];
        contract = new web3.eth.Contract(contractABI, contractAddress);
        document.getElementById("account").innerText = `Connected: ${currentAccount}`;
        loadUsers();
    } else {
        alert("Please install MetaMask!");
    }
});

async function addUser() {
    const userAddress = document.getElementById("userAddress").value;
    const name = document.getElementById("userName").value;
    const documentHash = document.getElementById("docHash").value;

    await contract.methods.addUser(userAddress, name, documentHash)
        .send({ from: currentAccount });

    alert("User added successfully!");
    loadUsers();
}

async function verifyUser() {
    const userAddress = document.getElementById("verifyAddress").value;

    await contract.methods.verifyUser(userAddress)
        .send({ from: currentAccount });

    alert("User verified!");
    loadUsers();
}

async function loadUsers() {
    const userAddresses = await contract.methods.getAllUsers().call();
    const table = document.getElementById("userTable");
    table.innerHTML = "<tr><th>Address</th><th>Name</th><th>Doc Hash</th><th>Verified</th></tr>";

    for (let addr of userAddresses) {
        const user = await contract.methods.getUser(addr).call();
        const row = `<tr><td>${addr}</td><td>${user[0]}</td><td>${user[1]}</td><td>${user[2]}</td></tr>`;
        table.innerHTML += row;
    }
}
