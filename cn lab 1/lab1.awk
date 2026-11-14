# Initialize the drop counter before reading the trace file
BEGIN {
    count = 0;
}

# Check every line in lab1.tr; column 1 ($1) holds the event type
# "d" stands for dropped packet
{
    if ($1 == "d") {
        count++;
    }
}

# Print the final count after scanning the entire trace file
END {
    printf("Total no. of packets dropped due to congestion is: %d\n", count);
}
