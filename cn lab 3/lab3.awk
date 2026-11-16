# Scan each line of the TCP trace file (file1.tr or file2.tr)
# Column 1 ($1) = Simulation Time
# Column 6 ($6) = Parameter name ("cwnd_")
# Column 7 ($7) = Congestion Window value
{
    if ($6 == "cwnd_") {
        printf("%f \t %f\n", $1, $7);
    }
}

# Print completion message to terminal
END { 
    print "DONE" > "/dev/stderr";
}
