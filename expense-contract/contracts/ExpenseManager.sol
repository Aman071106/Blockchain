//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract ExpenseManagerContract {
    
    //define owner of the contract
    address public owner;
    Transaction[] transactions;
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can nominate new owner");
        _;
    }
    
    //different public balances
    mapping(address => uint256) public balances;


    constructor(){
        owner = msg.sender;
    }

    //event for transaction-for frontend
    event Deposit(address indexed _from, uint256 _amount, string _reason,uint256 _timestamp);
    event Withdraw(address indexed _to, uint256 _amount, string _reason,uint256 _timestamp);
    

    //for transaction define a datastructure
    struct Transaction {
        uint256 timestamp;
        string reason;
        uint256 amount;
        address user;
    }
    //required functions
    function  deposit(string memory _reason, uint256 _amount)public payable{
        require(_amount > 0, "Dont't be cheap");
        balances[msg.sender] += _amount;
        transactions.push(Transaction(block.timestamp, _reason, _amount, msg.sender));
        emit Deposit(msg.sender, _amount, _reason, block.timestamp);
    }
    function withdraw(uint _amount,string memory _reason)public {
        require(balances[msg.sender] > _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        transactions.push(Transaction(block.timestamp, _reason, _amount, msg.sender));
        payable(msg.sender).transfer(_amount);
        emit Withdraw(msg.sender, _amount, _reason, block.timestamp);
    }
    function getBalance(address _user) public view returns(uint256) {
        return balances[_user];
        
    }
    function getTransactionsCount()public view returns(uint256) {
        return transactions.length;
        
    }
    function getTransaction(uint _index) public view returns(address,uint,string memory,uint256) {
        require(_index < transactions.length, "Invalid index");
        Transaction memory transaction = transactions[_index];
        return (transaction.user, transaction.amount, transaction.reason, transaction.timestamp);
        
    }
    function getAllTransactions()public view returns(address[] memory,uint[] memory,string[]memory,uint256[] memory) {
        address[] memory users = new address[](transactions.length);
        uint[] memory amounts = new uint[](transactions.length);    
        string[] memory reasons = new string[](transactions.length);
        uint256[] memory timestamps = new uint256[](transactions.length);
        for(uint256 i=0; i<transactions.length; i++) {
            Transaction memory transaction = transactions[i];
            users[i] = transaction.user;
            amounts[i] = transaction.amount;
            reasons[i] = transaction.reason;
            timestamps[i] = transaction.timestamp;

        }
        return (users, amounts, reasons, timestamps);
        
    }
    function changeOwner(string memory _reason, address _newOwner) public onlyOwner {
        owner = _newOwner;
        transactions.push(Transaction(block.timestamp, _reason, 0, msg.sender));
    }
    
    
}