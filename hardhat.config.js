require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const ALCHEMY_API_KEY = "moFfNuvVXa28N6eDcnuXC4wdjKXa4MLx";
const ROPSTEN_PRIVATE_KEY =
  "d070410d4a85d7c074871b12b074f007007e854a5994ee0594bcd9aa2ea946ed";

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    // hardhat: {},
    // development: {
    //   url: "http://127.0.0.1:8545",
    // },
    // quorum: {
    //   url: "http://127.0.0.1:22000",
    // },
    ropsten: {
      url: `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`${ROPSTEN_PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: "3F4DUIAD9JRBEC7HG989DM76IX94SQBWZA",
  },
  solidity: {
    version: "0.8.13",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 20000,
  },
};
