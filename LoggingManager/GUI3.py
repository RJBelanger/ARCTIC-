import tkinter as tk
from tkinter import ttk
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import os

class FileWatcherHandler(FileSystemEventHandler):
    def __init__(self, filename, update_callback):
        self.filename = filename
        self.update_callback = update_callback

    def on_modified(self, event):
        if event.src_path == self.filename:
            self.update_callback()

def read_status_from_file(filename):
    if not os.path.exists(filename):  # Check if the file exists
        return {}  # Return an empty dictionary if the file doesn't exist

    with open(filename, 'r', encoding='utf-16') as f:  # Specify the correct encoding
        lines = f.readlines()

    status_dict = {}
    for line in lines:
        cleaned_line = line.strip().replace('\x00', '')
        parts = cleaned_line.split(': ')
        if len(parts) == 2:
            status_dict[parts[0]] = int(parts[1])
    return status_dict

def update_display(frame, filename):
    for widget in frame.winfo_children():
        widget.destroy()

    status_dict = read_status_from_file(filename)
    for computer, status in status_dict.items():
        color = 'green' if status == 1 else 'yellow' if status == 2 else 'red'
        row_frame = tk.Frame(frame)
        row_frame.pack(fill=tk.X, padx=5, pady=5)
        lbl = tk.Label(row_frame, text=f"{computer}: {status}", bg=color, font=("Arial", 12))
        lbl.pack(side=tk.LEFT, expand=True, fill=tk.X)
        reset_button = tk.Button(row_frame, text="Reset", command=lambda comp=computer: reset_status(comp))
        reset_button.pack(side=tk.RIGHT)

def reset_status(computer):
    print(f"Reset button clicked for {computer}.")  # Placeholder for reset functionality

def main(filename):
    root = tk.Tk()
    root.title("Computer Health Status")

    frame = tk.Frame(root)
    frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

    update_display(frame, filename)

    event_handler = FileWatcherHandler(filename, lambda: update_display(frame, filename))
    observer = Observer()
    observer.schedule(event_handler, path=os.path.dirname(filename), recursive=False)
    observer.start()

    try:
        root.mainloop()
    finally:
        observer.stop()
        observer.join()

if __name__ == "__main__":
    filename = r"C:\Users\User2\Desktop\log_check_results.txt"  # Ensure this is the correct path
    main(filename)
