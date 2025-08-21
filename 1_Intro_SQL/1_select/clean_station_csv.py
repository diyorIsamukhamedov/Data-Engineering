# Open input file (space-separated values) and output file (comma-separated CSV)
with open("station.csv", "r") as infile, open("station_clean.csv", "w") as outfile:
    for line in infile:
        # Remove leading/trailing spaces and split the line by whitespace
        parts = line.strip().split()

        # First column is id
        id_col = parts[0]
        # Last three columns are always: state, lat_n, long_w
        state, lat_n, long_w = parts[-3:]
        # Everything in the middle belongs to the city (can be one or more words)
        city = " ".join(parts[1:-3])

        # Write to CSV with commas
        outfile.write(f"{id_col},{city},{state},{lat_n},{long_w}\n")
