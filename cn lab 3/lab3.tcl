# Create a new Simulator instance
set ns [new Simulator]

# Open main trace file to log all network events
set tf [open lab3.tr w]
$ns trace-all $tf

# Open NAM (Network Animator) file for visual animation
set nf [open lab3.nam w]
$ns namtrace-all $nf

# Create 4 nodes for the Ethernet LAN
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Define flow colors for NAM visualization
$ns color 1 "red"
$ns color 2 "blue"

# Create an Ethernet LAN connecting n0, n1, n2, and n3
# Parameters: <nodes> <bandwidth> <delay> <LinkLayer> <QueueType> <MAC_protocol>
$ns make-lan "$n0 $n1 $n2 $n3" 10Mb 10ms LL Queue/DropTail Mac/802_3

# --- First TCP Connection: Node n0 (Source) -> Node n3 (Destination) ---
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

# Attach an FTP application to generate bulk traffic over tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

# Create a TCP Sink (receiver) on node n3 and connect it to tcp0
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
$ns connect $tcp0 $sink3

# --- Second TCP Connection: Node n2 (Source) -> Node n1 (Destination) ---
set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2

# Attach an FTP application to generate bulk traffic over tcp2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

# Create a TCP Sink (receiver) on node n1 and connect it to tcp2
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
$ns connect $tcp2 $sink1

# Assign flow IDs to color the packets (1 = Red, 2 = Blue)
$tcp0 set class_ 1
$tcp2 set class_ 2

# --- Trace Congestion Window (cwnd_) for both TCP sources ---
# Open separate trace files to store congestion window changes over time
set file1 [open file1.tr w]
$tcp0 attach $file1
$tcp0 trace cwnd_
$tcp0 set maxcwnd_ 10

set file2 [open file2.tr w]
$tcp2 attach $file2
$tcp2 trace cwnd_

# Define the finish procedure to flush buffers, close all files, and launch NAM
proc finish {} {
    global nf tf ns file1 file2
    $ns flush-trace
    close $nf
    close $tf
    close $file1
    close $file2
    exec nam lab3.nam &
    exit 0
}

# Schedule start and stop times (in seconds) for FTP flow 0 (n0 -> n3)
$ns at 0.1 "$ftp0 start"
$ns at 1.5 "$ftp0 stop"
$ns at 2.0 "$ftp0 start"
$ns at 3.0 "$ftp0 stop"

# Schedule start and stop times (in seconds) for FTP flow 2 (n2 -> n1)
$ns at 0.2 "$ftp2 start"
$ns at 2.0 "$ftp2 stop"
$ns at 2.5 "$ftp2 start"
$ns at 4.0 "$ftp2 stop"

# End simulation at 5.0 seconds
$ns at 5.0 "finish"

# Start the simulation
$ns run
