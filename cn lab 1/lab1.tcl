# Create a new Simulator instance
set ns [new Simulator]

# Open trace file to record packet events (enqueue, dequeue, receive, drop)
set tf [open lab1.tr w]
$ns trace-all $tf

# Open NAM (Network Animator) file to visualize the simulation
set nf [open lab1.nam w]
$ns namtrace-all $nf

# Create 4 nodes: n0 & n1 (Sources), n2 (Router), n3 (Destination)
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Assign colors for packet flows in NAM visualization
$ns color 1 "red"
$ns color 2 "blue"

# Label the nodes for easy identification in NAM
$n0 label "Source/udp0"
$n1 label "Source/udp1"
$n2 label "Router"
$n3 label "Destination/Null"

# Create duplex links: <node1> <node2> <bandwidth> <delay> <queue_type>
# Vary the bandwidth (e.g., 10Mb vs 1Mb) to observe changes in packet drops
$ns duplex-link $n0 $n2 10Mb 300ms DropTail
$ns duplex-link $n1 $n2 10Mb 300ms DropTail
$ns duplex-link $n2 $n3 1Mb 300ms DropTail

# Set the maximum queue size (in packets) for each link
# Note: Correct NS2 syntax is '$ns queue-limit', not '$ns set queue-limit'
$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10
$ns queue-limit $n2 $n3 5

# Create UDP agent 0 and attach it to node n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# Create Constant Bit Rate (CBR) traffic generator and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

# Create UDP agent 1 and attach it to node n1
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1

# Create CBR traffic generator 1 and attach it to udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

# Create a Null agent (traffic sink/receiver) and attach it to destination n3
set null3 [new Agent/Null]
$ns attach-agent $n3 $null3

# Map flow IDs to the colors defined earlier (1 = Red, 2 = Blue)
$udp0 set class_ 1
$udp1 set class_ 2

# Connect both UDP sources to the Null destination
$ns connect $udp0 $null3
$ns connect $udp1 $null3

# Configure packet size (in bytes) and transmission interval (in seconds)
# Smaller interval = higher data rate = more congestion and packet drops
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005

$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005

# Define the finish procedure to flush traces, close files, and launch NAM
proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $tf
    close $nf
    exec nam lab1.nam &
    exit 0
}

# Schedule traffic start and simulation end times (in seconds)
$ns at 0.1 "$cbr0 start"
$ns at 0.1 "$cbr1 start"
$ns at 10.0 "finish"

# Start the simulation
$ns run
