# Create a new Simulator instance
set ns [new Simulator]

# Open trace file to log all packet events (enqueue, dequeue, receive, drop)
set tf [open lab2.tr w]
$ns trace-all $tf

# Open NAM (Network Animator) file to visualize the network
set nf [open lab2.nam w]
$ns namtrace-all $nf

# Create 7 nodes (n2 acts as the central router; others are end hosts)
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

# Assign readable labels to active nodes in the NAM window
$n0 label "Ping0"
$n2 label "Router"
$n4 label "Ping4"
$n5 label "Ping5"
$n6 label "Ping6"

# Define packet colors for different traffic flows
$ns color 1 "red"
$ns color 2 "green"

# Create duplex links connecting outer nodes to central router n2
# Format: <node1> <node2> <bandwidth> <propagation_delay> <queue_type>
# High bandwidth (100Mb) entering n2 and low bandwidth (1Mb) leaving n2 creates a bottleneck
$ns duplex-link $n0 $n2 100Mb 300ms DropTail
$ns duplex-link $n2 $n6 1Mb 300ms DropTail
$ns duplex-link $n5 $n2 100Mb 300ms DropTail
$ns duplex-link $n2 $n4 1Mb 300ms DropTail
$ns duplex-link $n3 $n2 1Mb 300ms DropTail
$ns duplex-link $n1 $n2 1Mb 300ms DropTail

# Set maximum queue buffer size (in packets) on key links
# Small queue sizes (2 and 3) on bottleneck links force congestion drops
$ns queue-limit $n0 $n2 5
$ns queue-limit $n2 $n6 2
$ns queue-limit $n2 $n4 3
$ns queue-limit $n5 $n2 5

# Create Ping agents and attach them to nodes n0, n4, n5, and n6
set ping0 [new Agent/Ping]
$ns attach-agent $n0 $ping0

set ping4 [new Agent/Ping]
$ns attach-agent $n4 $ping4

set ping5 [new Agent/Ping]
$ns attach-agent $n5 $ping5

set ping6 [new Agent/Ping]
$ns attach-agent $n6 $ping6

# Set packet sizes (in bytes) and sending intervals (in seconds)
# Large packet sizes (50KB & 60KB) quickly fill up the 1Mb bottleneck links
$ping0 set packetSize_ 50000
$ping0 set interval_ 0.0001

$ping5 set packetSize_ 60000
$ping5 set interval_ 0.00001

# Assign flow IDs so ping0 packets appear red and ping5 packets appear green
$ping0 set class_ 1
$ping5 set class_ 2

# Connect ping pairs: n0 <-> n4 and n5 <-> n6
$ns connect $ping0 $ping4
$ns connect $ping5 $ping6

# Define the 'recv' callback procedure for Agent/Ping
# Triggered automatically whenever a node receives a ping reply, printing Round-Trip Time (RTT)
Agent/Ping instproc recv {from rtt} {
    $self instvar node_
    puts "The node [$node_ id] received a reply from $from with round trip time of $rtt ms"
}

# Define the finish procedure to flush buffers, close files, and open NAM
proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $tf
    close $nf
    exec nam lab2.nam &
    exit 0
}

# Simulate a link failure between router n2 and node n6 from t=0.9s to t=1.5s
# Packets sent toward n6 during this window will be dropped
$ns rtmodel-at 0.9 down $n2 $n6
$ns rtmodel-at 1.5 up $n2 $n6

# Schedule ping0 (n0 -> n4) to send packets every 0.1s from 0.1s to 1.8s
for {set t 0.1} {$t <= 1.85} {set t [expr $t + 0.1]} {
    $ns at $t "$ping0 send"
}

# Schedule ping5 (n5 -> n6) to send packets every 0.1s from 0.1s to 1.8s
for {set t 0.1} {$t <= 1.85} {set t [expr $t + 0.1]} {
    $ns at $t "$ping5 send"
}

# End the simulation at 5.0 seconds
$ns at 5.0 "finish"

# Start the simulation
$ns run
