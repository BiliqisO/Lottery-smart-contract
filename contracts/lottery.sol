// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

 contract LotteryGame   {

    struct Lottery{
        uint lotteryId;
        uint lotteryPot; //balance of the lottery
        uint lotteryPurchaseWindow;
        uint Ticket;
        uint minPriceOfTicket;
        address[] ticketOwners;
        mapping (address => uint) mapTicket;
        mapping (address => uint) lotterBalance;
        address winner;
        bool isActive;  
        uint ticketId;  
    }
    mapping (uint => Lottery) mapLottery;
    uint LotteryId;
    address ticketer;
    uint blockLiimt;
    

    function createLottery(uint _minPriceOfTicket) public {
        LotteryId++;  
        mapLottery[LotteryId].lotteryId = LotteryId;
        mapLottery[LotteryId].minPriceOfTicket = _minPriceOfTicket ;
        mapLottery[LotteryId].lotteryPurchaseWindow = block.timestamp + 24 hours ;
        mapLottery[LotteryId].isActive = true; 
    }
    function purchaseTickets(uint _LotteryId) public  payable   {
        require(block.timestamp < mapLottery[LotteryId].lotteryPurchaseWindow , "ticket purchase time over");
        require(msg.value >= mapLottery[_LotteryId].minPriceOfTicket, "Incorrect payment amount");
         require(mapLottery[_LotteryId].isActive , "lottery not active");
          mapLottery[_LotteryId].ticketId++;
         require( mapLottery[_LotteryId].mapTicket[msg.sender] == 0 , "you already have a ticket");  
            mapLottery[_LotteryId].lotteryPot += msg.value; 
            //no of tickets purchased in a lottery
            mapLottery[_LotteryId].Ticket = mapLottery[_LotteryId].ticketId ;
            ticketer = msg.sender;
            //ticketId of a particular ticket owner
            mapLottery[_LotteryId].mapTicket[ticketer] =  mapLottery[_LotteryId].ticketId;
            mapLottery[_LotteryId].lotterBalance[ticketer]+= msg.value ;
            mapLottery[_LotteryId].ticketOwners.push(ticketer);     
    }
  
   function getRandom() public view returns (uint){
    return uint256(blockhash(block.number-1));
   }
    function showWinner(uint _LotteryId) public { 
       require(block.timestamp >= mapLottery[LotteryId].lotteryPurchaseWindow + 1 hours, "winners can only be declared one hour after"); 
       uint winnerIndex = getRandom() % mapLottery[_LotteryId].ticketOwners.length;
       blockLiimt = block.number + 255;
       mapLottery[_LotteryId].winner = mapLottery[_LotteryId].ticketOwners[winnerIndex] ;
   }

    function claimWinnings(uint _LotteryId) public  { 
        if(block.number < blockLiimt){
                payable (mapLottery[_LotteryId].winner).transfer(address(this).balance);
        }else {
        for (uint i = 0; i < mapLottery[_LotteryId].ticketOwners.length; i++) {
                address lotters = mapLottery[_LotteryId].ticketOwners[i];
                uint lottersBalanced = mapLottery[_LotteryId].lotterBalance[lotters];
                payable(lotters).transfer(lottersBalanced);
                mapLottery[_LotteryId].lotterBalance[ticketer] -= lottersBalanced;
            }
        }
       mapLottery[_LotteryId].lotteryPot -= address(this).balance;
       mapLottery[_LotteryId].isActive = false;
 
    }
      function showTicket(uint _LotteryId, address myAddr)public view returns (uint,uint, address[] memory, uint, uint) {
        return( mapLottery[_LotteryId].lotteryId,  mapLottery[_LotteryId].lotteryPot,mapLottery[_LotteryId].ticketOwners, mapLottery[_LotteryId].Ticket, mapLottery[_LotteryId].lotterBalance[myAddr]  );

    }
 }


   