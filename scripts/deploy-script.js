const { utils } = require("ethers");
const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const primaryToken = await ethers.getContractFactory("MainToken");
  const tokenContract = await primaryToken.deploy();
  await tokenContract.deployed();

  const vendor = await ethers.getContractFactory("Vendor");
  const vendorContract = await vendor.deploy(tokenContract.address);
  await vendorContract.deployed();

  const result = await tokenContract.transfer(
    vendorContract.address,
    utils.parseEther(1000000)
  );

  console.log(result);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
