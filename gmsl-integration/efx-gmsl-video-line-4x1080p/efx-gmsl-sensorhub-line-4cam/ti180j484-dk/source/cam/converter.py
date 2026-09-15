import csv
import argparse
import os

def main():
    # Set up the command line arguments
    parser = argparse.ArgumentParser(description="Convert hex CSV to vertical bytes, ignoring comments.")
    parser.add_argument('--in', dest='input_file', required=True, help="Input CSV file")
    parser.add_argument('--out', dest='output_file', required=True, help="Output text file")
    
    args = parser.parse_args()

    if not os.path.exists(args.input_file):
        print(f"Error: {args.input_file} not found.")
        return

    try:
        with open(args.input_file, 'r') as f_in, open(args.output_file, 'w') as f_out:
            for line in f_in:
                # 1. Remove comments: ignore everything after the '#' character
                line_content = line.split('#')[0].strip()
                
                if not line_content:
                    continue
                
                # 2. Split by space or comma
                parts = line_content.replace(',', ' ').split()
                
                for item in parts:
                    # Clean the hex string
                    hex_val = item.upper().replace('0X', '')
                    
                    # 3. Handle Padding (e.g., 100 -> 0100)
                    if 2 < len(hex_val) < 4:
                        hex_val = hex_val.zfill(4)
                    elif len(hex_val) % 2 != 0:
                        hex_val = '0' + hex_val
                    
                    # 4. Split into bytes and reverse (Little Endian)
                    bytes_list = [hex_val[i:i+2] for i in range(0, len(hex_val), 2)]
                    for b in bytes_list: #reversed(bytes_list):
                        f_out.write(f"{b}\n")
                        
        print(f"Success! Processed {args.input_file} into {args.output_file}")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()