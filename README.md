# Hazard Detection Unit

## Overview
This project implements a **Hazard Detection Unit** in **Verilog** for a pipelined processor. The module ensures proper **data forwarding** and **stalling mechanisms** to mitigate pipeline hazards. It is designed in **Quartus** and follows a **synchronous design** using a clock (`clk`) for coordination.

## Module Definition
```verilog
module HazardUnit(
    input clk,
    input [4:0] rsD, rtD, rtE, rsE,
    input [4:0] WrtregM, WrtregW, WrtregE,
    input Mem2reg,
    input RegwrtM, RegwrtW, RegwrtE,
    output reg forwardAD, forwardBD, forwardAE, forwardBE,
    output reg stallF, stallD, flushE
);
```

## Functional Blocks
### **1. Forwarding Logic (`forwardAD`, `forwardBD`)**
Manages forwarding at the **Decode (ID) stage**.
```verilog
assign ForwardAD = (rsD != 0) && (rsD == WrtregM) && RegwrtM;
assign ForwardBD = (rtD != 0) && (rtD == WrtregM) && RegwrtM;
```

### **2. Execution Forwarding (`forwardAE`, `forwardBE`)**
Manages forwarding at the **Execution (EXE) stage**.
```verilog
always @(posedge clk) begin
    if (rsE != 0 && rsE == WrtregM && RegwrtM)
        ForwardAE = 2'b10;
    else if (rsE != 0 && rsE == WrtregW && RegwrtW)
        ForwardAE = 2'b01;
    else
        ForwardAE = 2'b00;
end
```

### **3. Stall Logic (`stallF`, `stallD`, `flushE`)**
Handles **load-use dependencies** and **branch hazards**.
```verilog
assign LwStall = (BranchD && RegwrtE && (WrtregE == rsD || WrtregE == rtD)) ||
                 (BranchD && Mem2reg && (WrtregM == rsD || WrtregM == rtD));
assign StallF = StallD = FlushE = LwStall;
```

## Pipeline Integration
- Works across **ID/EXE, EXE/MEM, MEM/WB** stages.
- Ensures **hazard-free execution** via **forwarding and stalling mechanisms**.
- Fully synthesized with **RTL Viewer** verification.

## Installation & Simulation
### **Prerequisites**
- **Quartus Prime** (for RTL verification)
- **ModelSim** (for functional simulation)

### **Steps to Simulate**
```sh
# Clone the repository
git clone https://github.com/ppakshad/HazardUnit-.git
cd hazard-unit

# Compile in ModelSim
vlog HazardUnit.v
vsim HazardUnit

# Run simulation
run -all
```

## Outputs & Verification
- **RTL Viewer confirms logical correctness.**
- **Simulation results validate hazard detection.**

## Author
**Puya Pakshad**  
- Contact: [ppakshad@hawk.iit.edu]

## License
MIT License.
