// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Token.sol";

contract Vendor is Ownable {
    // Define token
    MainToken primaryToken;

    // Using SafeMath 
    using SafeMath for uint256;

    // Define variable 
    uint256 public tokensPerEth = 10;

    // Define event 
    event BuyTokens(address buyer, uint256 ethAmount, uint256 tokenAmount);
    event SellTokens(address seller, uint256 tokenAmount, uint256 ethAmount);

    constructor (address tokenAddress){
        primaryToken = MainToken(tokenAddress);
    }

    function buyTokens() public payable returns(bool) {
        uint256 amountTokenToBuy = msg.value.mul(tokensPerEth);
        require(amountTokenToBuy >= primaryToken.balanceOf(address(this)),"Contract is not enough token to sell !!!");

        (bool sent) = primaryToken.transfer(msg.sender, amountTokenToBuy);
        require(sent, "Sending token has been failed !");

        emit BuyTokens(msg.sender, msg.value, amountTokenToBuy);
        return true;
    }

    function sellTokens(uint256 amount) public payable returns(bool) {
        require(amount > 0, "Amount to sell have to more than 0");

        uint sellerTokenBalance = primaryToken.balanceOf(msg.sender);
        require(sellerTokenBalance >= amount ,"Your token balance is not enough to sell !!!");


        uint256 ethAmount = amount.div(tokensPerEth);
        uint256 contractEthBalance = address(this).balance;
        require(ethAmount >=contractEthBalance, "Contract balance is not enough eth to pay a transaction !!!");

        (bool sent) = primaryToken.transferFrom(msg.sender, address(this), amount);
        require(sent, "Transfer token is failed !!!");

        (sent, ) = msg.sender.call{value : ethAmount}("");
        require(sent, "Transfer ETH to contract is failed");

        return true;
        
    }

    function withdrawEth(uint256 amount) public payable onlyOwner returns(bool) {
        uint totalEthBalance = address(this).balance;
        require(amount >= totalEthBalance, "Eth balance of contract is not enough to withdraw");

        (bool sent, ) = msg.sender.call{value : amount}("");
        require(sent, "Send eth is failed !!!");

        return true;
    }

    function withdrawToken(uint256 amount) public payable onlyOwner returns(bool) {
        uint256 remainToken = primaryToken.balanceOf(address(this));
        require(amount >= remainToken, "Token balance is not enough to withdraw");

        (bool sent) = primaryToken.transfer(msg.sender, amount);
        require(sent, "Send token is failed !!!");

        return true;
    }
}

