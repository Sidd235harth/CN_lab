# Initialize packet drop counter
BEGIN {
    count = 0;
}

# Scan every line in lab2.tr; column 1 ($1) records the event type
# "d" indicates a dropped packet (due to queue overflow or link failure)
{
    if ($1 == "d") {
        count++;
    }
}

# Output the total dropped packets at the end of the trace file
END {
    printf("Total no. of packets dropped due to congestion is: %d\n", count);
}
