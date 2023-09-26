import { ethers } from "hardhat";

async function main() {
  const lotteryGame = await ethers.deployContract("LotteryGame");

  await lotteryGame.waitForDeployment();

  console.log(`deployed to ${lotteryGame.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
