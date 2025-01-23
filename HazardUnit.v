module HazardUnit(clk,rsD, rtD, rtE, rsE, BranchD,WrtregM, WrtregW, WrtregE, Mem2reg, RegwrtM, RegwrtW, RegwrtE, forwardAD, forwardBD, forwardAE, forwardBE, stallF, stallD, flushE); 
   input[4:0] rsD,rtD,rtE,rsE,WrtregM,WrtregW,WrtregE; 
   input clk; 
   wire Lwstall;
   input Mem2reg,RegwrtM,RegwrtW,RegwrtE,BranchD; 
   output[1:0] forwardAD, forwardBD, forwardAE, forwardBE; 
   output stallF,stallD,flushE;
	//reg stallF,stallD,flushE;
   reg[1:0] forwardAD, forwardBD,forwardAE,forwardBE; 
   //logic forwardAD_BD
   //ForwardAD = (rsD !=0) AND (rsD == WriteRegM) AND RegWriteM
   //ForwardBD = (rtD !=0) AND (rtD == WriteRegM) AND RegWriteM
   //FORWARD AD
   always@(posedge clk) 
   begin 
      if((rsD != 0)&&(rsD == WrtregM)&&(RegwrtM)) 
         forwardAD = 2'b10; 
	  else 
	     forwardAD = 2'b00;
   end 
   //FORWARD BD
   always@(posedge clk) 
   begin 
      if((rtD != 0)&&(rtD == WrtregM)&&(RegwrtM)) 
         forwardBD = 2'b10; 
	  else 
	     forwardBD = 2'b00;
   end 
   //logic forwardAE_BE
   //if (rsE != 0 AND rsE == WriteRegM AND RegWriteM)
	//then ForwardAE = 10
	//else if (rsE != 0 AND rsE == WriteRegW AND RegWriteW)
	//then ForwardAE = 01
	//else ForwardAE = 00
	//fORWARD AE
always@(posedge clk) 
	begin 
     if((rsE != 0)&&(rsE == WrtregM)&&(RegwrtM)) 
         forwardAE = 2'b10; 
	  if((rsE != 0)&&(rsE == WrtregW)&&(RegwrtW))
	     forwardAE = 2'b01;
	  else 
	     forwardAE = 2'b00;
  end 
  //fORWARD BE
  always@(posedge clk) 
	begin 
     if((rtE != 0)&&(rtE == WrtregM)&&(RegwrtM)) 
         forwardBE = 2'b10; 
	  if((rtE != 0)&&(rtE == WrtregW)&&(RegwrtW))
	     forwardBE = 2'b01;
	  else 
	     forwardBE = 2'b00;
  end
  //Staling Hardware logic :
  //Lwstall = (BranchD AND
  //RegWriteE AND
  //(WriteRegE == rsD OR WriteRegE == rtD))
  //OR
  //(BranchD AND
  //MemtoRegM AND
  //(WriteRegM == rsD OR WriteRegM == rtD))
   //StallF = StallD = FlushE = lwstall OR branchstall
   assign Lwstall = ((BranchD && RegwrtE &&((WrtregE==rsD)||(WrtregE==rtD))) || (BranchD && Mem2reg &&((WrtregM==rsD)||(WrtregM==rtD))));
   assign StallF = Lwstall;
   assign StallD = Lwstall;
   assign FlushE = Lwstall;
endmodule
