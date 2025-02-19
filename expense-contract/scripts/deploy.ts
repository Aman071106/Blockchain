import { ethers } from "hardhat";

async function main() {
  const ExpenseManager = await ethers.getContractFactory("ExpenseManagerContract");
  
  // Deploy contract
  const contract = await ExpenseManager.deploy();

  // Wait for deployment to complete
  await contract.waitForDeployment();

  // Get contract address
  const contractAddress = await contract.getAddress();

  console.log("Contract deployed to:", contractAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
