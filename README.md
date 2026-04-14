# Traffic Light Controller — RTL to GDS

A fully open-source ASIC implementation of a Traffic Light Controller, taking the design from a Verilog FSM all the way to a verified GDSII layout using the Sky130A PDK.

---

## Overview

| Property | Value |
|---|---|
| Design | Traffic Light Controller (FSM) |
| PDK | Sky130A (SkyWater 130nm) |
| Flow | OpenLane v1.0.2 |
| Synthesis | Yosys |
| Simulation | Icarus Verilog + GTKWave |
| Verification | KLayout, Netgen, OpenSTA |
| DRC / LVS / STA | ✅ Clean — Zero violations |

---

## Block Diagram / Flow

```
Verilog RTL
    │
    ▼
Simulation (Icarus Verilog + GTKWave)
    │
    ▼
Synthesis (Yosys → Sky130 standard cells)
    │
    ▼
Place & Route (OpenLane v1.0.2)
├── Floorplanning
├── Placement
├── Clock Tree Synthesis (CTS)
└── Routing
    │
    ▼
Signoff (DRC ✅ | LVS ✅ | STA ✅)
    │
    ▼
GDSII Export → Verified in KLayout
```

---

## Repository Structure

```
traffic_light/
├── src/
│   └── trafficlight_controller.v     # RTL design
├── tb/
│   └── tb_trafficlight_controller.v  # Testbench
├── config.json                        # OpenLane configuration
├── results/
│   └── final/
│       ├── gds/trafficlight_controller.gds
│       ├── netlist/trafficlight_controller.v
│       └── reports/                  # Timing, DRC, LVS reports
└── README.md
```

---

## RTL Design

The Traffic Light Controller is implemented as a Finite State Machine (FSM) with the following states:

| State | Outputs (R/G/Y) | Description |
|---|---|---|
| RED | 1 / 0 / 0 | Stop |
| GREEN | 0 / 1 / 0 | Go |
| YELLOW | 0 / 0 / 1 | Caution |

**Inputs:** `clk`, `rst`, `hwy[1]`, `road[1]`  
**Outputs:** `road[0]`, `road[1]`

---

## Simulation

```bash
iverilog -o sim src/trafficlight_controller.v tb/tb_trafficlight_controller.v
vvp sim
gtkwave dump.vcd
```

---

## Synthesis

```bash
yosys -p "synth_sky130 -top trafficlight_controller; write_verilog synth.v" src/trafficlight_controller.v
```

---

## OpenLane PnR Flow

**Requirements:**
- Docker
- OpenLane v1.0.2
- Sky130A PDK

```bash
cd ~/OpenLane
make mount
./flow.tcl -design traffic_light
```

**config.json:**
```json
{
  "DESIGN_NAME": "trafficlight_controller",
  "VERILOG_FILES": "dir::src/*.v",
  "CLOCK_PORT": "clk",
  "CLOCK_PERIOD": 10,
  "FP_CORE_UTIL": 50,
  "PL_TARGET_DENSITY": 0.55,
  "FP_SIZING": "absolute",
  "DIE_AREA": "0 0 100 100",
  "PDK": "sky130A",
  "STD_CELL_LIBRARY": "sky130_fd_sc_hd"
}
```

---

## Results

| Check | Result |
|---|---|
| DRC (KLayout) | ✅ 0 violations |
| LVS (Netgen) | ✅ Pass |
| Setup Timing (OpenSTA) | ✅ No violations |
| Hold Timing (OpenSTA) | ✅ No violations |

### GDS Layout (KLayout)

![GDS Layout](results/final/gds/layout_screenshot.png)

---

## Tools Used

| Tool | Purpose |
|---|---|
| Icarus Verilog | RTL Simulation |
| GTKWave | Waveform Viewer |
| Yosys | Logic Synthesis |
| OpenLane v1.0.2 | RTL-to-GDS Flow (Synthesis → PnR → Signoff) |
| OpenROAD | Place & Route (inside OpenLane) |
| Netgen | LVS (inside OpenLane) |
| OpenSTA | Static Timing Analysis (inside OpenLane) |
| KLayout | GDS Viewer + DRC |
| Sky130A PDK | 130nm Process |

---


---

## License

MIT License
