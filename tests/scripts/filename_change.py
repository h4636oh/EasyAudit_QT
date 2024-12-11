import os

def rename_files_in_directory(directory):
    for filename in os.listdir(directory):
        if ".remed" in filename:
            new_filename = filename.replace(".remed", "_remed")
            os.rename(
                os.path.join(directory, filename),
                os.path.join(directory, new_filename)
            )
    print(f"Files in directory '{directory}' have been renamed.")

if __name__ == "__main__":
    # Replace with the path to your directory
    rename_files_in_directory("remediations")

