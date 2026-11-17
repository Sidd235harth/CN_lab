# CN_lab
## Program 1: Three-Node Point-to-Point Network (Packet Drop Analysis)

**Files:** `lab1.tcl`, `lab1.awk`

### Run
```bash
ns lab1.tcl
awk -f lab1.awk lab1.tr
```

### Sample Output
```text
Total no. of packets dropped due to congestion is: 249
```
*(Vary the bottleneck link bandwidth in `lab1.tcl`, e.g., `1Mb` to `2Mb` or `5Mb`, and re-run both commands to observe changes in packet drops.)*

---

## Program 2: Ping Message Transmission Over a Network Topology

**Files:** `lab2.tcl`, `lab2.awk`

### Run
```bash
ns lab2.tcl
awk -f lab2.awk lab2.tr
```

### Sample Output
```text
The node 0 received a reply from 4 with round trip time of 1200.4 ms
...
Total no. of packets dropped due to congestion is: 20
```
*(Modify bandwidth and `queue-limit` values on links `n0-n2`, `n2-n4`, `n5-n2`, and `n2-n6` in `lab2.tcl` to compare packet drops.)*

---

## Program 3: Ethernet LAN & TCP Congestion Window (`cwnd_`) Plotting

**Files:** `lab3.tcl`, `lab3.awk`

### Run
```bash
ns lab3.tcl
awk -f lab3.awk file1.tr > tcp0
awk -f lab3.awk file2.tr > tcp1
xgraph -x "Time (s)" -y "Congestion Window (cwnd)" tcp0 tcp1
```

---
## Program 4 & 5:
### Run
```bash
javac fileName.java
java fileName
```
