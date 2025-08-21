# Open input file (space-separated values) and output file (comma-separated CSV)
with open("city.csv", "r") as infile, open("city_clean.csv", "w") as outfile:
    for line_number, line in enumerate(infile):
        # If this is the header line, copy it directly and continue
        if line_number == 0:
            outfile.write("id,city_name,country_code,district,population\n")
            continue

        # Remove leading/trailing spaces and split the line by whitespace
        parts = line.strip().split()

        # First element is always the ID
        id_col = parts[0]
        # Last element is always the population
        population = parts[-1]

        # Find the country_code (always a 3-letter alphabetic code, located before district)
        for i, part in enumerate(parts):
            if len(part.strip()) == 3 and part.strip().isalpha():  # ISO country code
                country_code_index = i
                break

        # Extract the country code
        country_code = parts[country_code_index]

        # City name is everything between ID and country code
        city_name = " ".join(parts[1:country_code_index])
        # District is everything between country code and population
        district = " ".join(parts[country_code_index+1:-1])

        # Write cleaned line to CSV with commas
        outfile.write(f"{id_col},{city_name},{country_code},{district},{population}\n")