
import threading
import tkinter as tk
from tkinter import simpledialog, messagebox
import pandas as pd
import itertools
import serial  # برای ارتباط سریال

# ذخیره جداول و دنباله‌ها
tables = {}
sequences = {}  # برای ذخیره دنباله‌ها
circuit_inputs = {"in0" : -1,
                  "in1" : -1,
                  "in2" : -1,
                  "in3" : -1,
                  "in4" : -1,
                  "in5" : -1,
                  "in6" : -1,
                  "in7" : -1}
ciruit_variables = {}
variable_numbers = {"in0": 2,
                    "in1": 3,
                    "in2": 4,
                    "in3": 5,
                    "in4": 6,
                    "in5": 7,
                    "in6": 8,
                    "in7": 9,
                    "led0": 10,
                    "led1": 11,
                    "led2": 12,
                    "led3": 13}
table_numbers = {}
MAX_VARIABLE_NUMBER = 13
TABLE_COUNT = 0

# تابع برای درخواست ورودی عددی
def ask_for_integer(prompt):
    while True:
        try:
            return int(simpledialog.askstring("ورودی", prompt))
        except (ValueError, TypeError):
            messagebox.showerror("خطا", "لطفاً فقط یک عدد وارد کنید.")

# تابع برای درخواست مقدار خروجی (فقط 0 یا 1)
def ask_for_binary(prompt):
    while True:
        try:
            value = int(simpledialog.askstring("ورودی", prompt))
            if value in (0, 1):
                return value
            else:
                messagebox.showerror("خطا", "لطفاً فقط مقدار 0 یا 1 وارد کنید.")
        except (ValueError, TypeError):
            messagebox.showerror("خطا", "لطفاً فقط مقدار 0 یا 1 وارد کنید.")

# تابع برای ایجاد جدول جدید
def create_new_table():
    global MAX_VARIABLE_NUMBER
    global TABLE_COUNT
    table_name = simpledialog.askstring("نام جدول", "لطفاً نام جدول جدید را وارد کنید:")
    if table_name and table_name not in tables:
        TABLE_COUNT += 1
        table_numbers[table_name] = TABLE_COUNT
        num_inputs = ask_for_integer("تعداد ورودی‌ها را وارد کنید:")
        num_outputs = ask_for_integer("تعداد خروجی‌ها را وارد کنید:")

        # گرفتن نام‌های ورودی‌ها
        input_names = []
        input_numbers = []
        for i in range(num_inputs):
            input_name = simpledialog.askstring("نام ورودی", f"لطفاً نام ورودی {i+1} را وارد کنید:")
            input_names.append(input_name)
            if (input_name not in variable_numbers):
                MAX_VARIABLE_NUMBER += 1
                variable_numbers[input_name] = MAX_VARIABLE_NUMBER
            input_numbers.append(variable_numbers[input_name])

        # گرفتن نام‌های خروجی‌ها
        output_names = []
        output_numbers = []
        for i in range(num_outputs):
            output_name = simpledialog.askstring("نام خروجی", f"لطفاً نام خروجی {i+1} را وارد کنید:")
            output_names.append(output_name)
            if (output_name not in variable_numbers):
                MAX_VARIABLE_NUMBER += 1
                variable_numbers[output_name] = MAX_VARIABLE_NUMBER
            output_numbers.append(variable_numbers[output_name])

        # محاسبه تعداد سطرها و ایجاد ستون‌ها
        input_combinations = list(itertools.product([0, 1], repeat=num_inputs))
        columns = input_names + output_names
        df = pd.DataFrame(columns=columns)

        # لیست برای ذخیره مقادیر دهدهی
        decimal_values = []

        # گرفتن مقادیر خروجی برای تمام حالت‌ها
        for i, combination in enumerate(input_combinations):
            outputs = []
            combination_str = ", ".join([f"{name}={val}" for name, val in zip(input_names, combination)])
            for j, output_name in enumerate(output_names):
                output_value = ask_for_binary(f"مقدار {output_name} برای {combination_str}:")
                outputs.append(output_value)
            df.loc[i] = list(combination) + outputs

            # محاسبه مقدار دهدهی خروجی‌ها
            binary_output = "".join(map(str, outputs))  # ترکیب مقادیر خروجی به صورت رشته باینری
            decimal_value = int(binary_output, 2)  # تبدیل باینری به دهدهی
            decimal_values.append(decimal_value)

        # ذخیره جدول
        tables[table_name] = df

        # ایجاد دنباله و ذخیره آن
        sequence = [str(table_numbers[table_name]), str(num_inputs), str(num_outputs)] + list(map(str, input_numbers)) + list(map(str, output_numbers)) + list(map(str, decimal_values))
        sequences[table_name] = sequence

        messagebox.showinfo("موفقیت", f"جدول {table_name} با موفقیت ایجاد شد.\nدنباله مربوطه ذخیره شد.")

    elif table_name in tables:
        messagebox.showerror("خطا", "جدولی با این نام قبلاً وجود دارد.")
    else:
        messagebox.showwarning("خطا", "نام جدول وارد نشده است.")

# تابع برای ارسال دنباله به آردوینو
def send_to_arduino():
    if not sequences:
        messagebox.showwarning("هشدار", "هیچ دنباله‌ای برای ارسال وجود ندارد.")
        return

    # انتخاب جدول برای ارسال دنباله
    table_name = simpledialog.askstring("انتخاب جدول", f"نام یکی از جداول زیر را وارد کنید:\n{list(sequences.keys())}")
    if table_name in sequences:
        try:
            # تنظیم پورت سریال (نام پورت ممکن است متفاوت باشد)
            
            arduino = serial.serial_for_url('rfc2217://localhost:4000', baudrate=9600)
            data = ','.join(sequences[table_name])  # تبدیل دنباله به رشته
            arduino.write((data + '\n').encode())  # ارسال رشته به آردوینو
            arduino.close()
            messagebox.showinfo("ارسال موفق", f"داده‌های جدول {table_name} به آردوینو ارسال شد.")
        except Exception as e:
            messagebox.showerror("خطا", f"خطا در ارسال داده‌ها به آردوینو: {str(e)}")
    else:
        messagebox.showerror("خطا", "جدول انتخاب شده وجود ندارد.")

# تابع برای مشاهده جدول
def view_table():
    if not tables:
        messagebox.showwarning("هشدار", "هیچ جدولی برای نمایش وجود ندارد.")
        return

    # نمایش لیستی از نام جداول
    table_name = simpledialog.askstring("انتخاب جدول", f"نام یکی از جداول زیر را وارد کنید:\n{list(tables.keys())}")
    if table_name in tables:
        df = tables[table_name]

        # ایجاد پنجره جدید برای نمایش جدول
        view_window = tk.Toplevel(tk.Tk())
        view_window.title(f"نمایش جدول: {table_name}")
        view_window.state("zoomed")  # تمام صفحه کردن پنجره

        # ایجاد Canvas برای رسم جدول
        canvas = tk.Canvas(view_window, bg="white")
        canvas.pack(fill="both", expand=True)

        # گرفتن اندازه پنجره
        view_window.update_idletasks()
        window_width = view_window.winfo_width()
        window_height = view_window.winfo_height()

        # تنظیمات جدول
        cell_width = window_width // (len(df.columns) + 1)
        cell_height = window_height // (len(df) + 2)
        x_offset = 20
        y_offset = 20

        # رسم ستون‌ها (عنوان‌ها)
        for i, col in enumerate(df.columns):
            x0 = x_offset + i * cell_width
            y0 = y_offset
            x1 = x0 + cell_width
            y1 = y0 + cell_height
            canvas.create_rectangle(x0, y0, x1, y1, fill="#ADD8E6", outline="black")  # آبی برای ورودی‌ها
            canvas.create_text((x0 + x1) // 2, (y0 + y1) // 2, text=col, font=("Arial", 14, "bold"))

        # رسم داده‌های جدول
        for row_index, row in df.iterrows():
            for col_index, value in enumerate(row):
                x0 = x_offset + col_index * cell_width
                y0 = y_offset + (row_index + 1) * cell_height
                x1 = x0 + cell_width
                y1 = y0 + cell_height
                color = "#ADD8E6" if col_index < get_log(df.shape[0]) else "#90EE90"  # آبی برای ورودی، سبز برای خروجی
                canvas.create_rectangle(x0, y0, x1, y1, fill=color, outline="black")
                canvas.create_text((x0 + x1) // 2, (y0 + y1) // 2, text=str(value), font=("Arial", 12))

    else:
        messagebox.showerror("خطا", "جدول انتخاب شده وجود ندارد.")

# تابع برای حذف جدول
def delete_table():
    if not tables:
        messagebox.showwarning("هشدار", "هیچ جدولی برای حذف وجود ندارد.")
        return

    # نمایش لیستی از نام جداول
    table_name = simpledialog.askstring("حذف جدول", f"نام یکی از جداول زیر را وارد کنید:\n{list(tables.keys())}")
    if table_name in tables:
        del tables[table_name]
        del sequences[table_name]  # حذف دنباله مرتبط با جدول
        messagebox.showinfo("موفقیت", f"جدول {table_name} و دنباله مربوطه حذف شد.")
    else:
        messagebox.showerror("خطا", "جدول انتخاب شده وجود ندارد.")

def clear_arduino():
    try:
        arduino = serial.serial_for_url('rfc2217://localhost:4000', baudrate=9600)
        arduino.write(b'clear')
        arduino.close()
        messagebox.showinfo("ارسال موفق", "پیام حذف به آردوینو ارسال شد")
    except Exception as e:
        messagebox.showerror("خطا", f" خطا در ارسال پیام به آردوینو {str(e)}")

def create_gui():
    # ساخت پنجره اصلی
    window = tk.Tk()
    window.title("مدیریت جداول با Pandas") 
    window.state("zoomed")
    window.configure(bg="#F8BBD0")

    # فریم اصلی منو
    menu_frame = tk.Frame(window, bg="#F8BBD0")
    menu_frame.pack(pady=50)

    # دکمه‌ها
    btn_create = tk.Button(menu_frame, text="ایجاد جدول جدید", command=create_new_table, bg="#FF80AB", fg="white", font=('Arial', 12, 'bold'), relief="ridge", width=20, height=2)
    btn_create.grid(row=0, column=0, padx=10, pady=10)

    btn_view = tk.Button(menu_frame, text="مشاهده جدول", command=view_table, bg="#FF80AB", fg="white", font=('Arial', 12, 'bold'), relief="ridge", width=20, height=2)
    btn_view.grid(row=1, column=0, padx=10, pady=10)

    btn_send = tk.Button(menu_frame, text="ارسال به آردوینو", command=send_to_arduino, bg="#FF80AB", fg="white", font=('Arial', 12, 'bold'), relief="ridge", width=20, height=2)
    btn_send.grid(row=2, column=0, padx=10, pady=10)

    btn_delete = tk.Button(menu_frame, text="حذف جدول", command=delete_table, bg="#FF80AB", fg="white", font=('Arial', 12, 'bold'), relief="ridge", width=20, height=2)
    btn_delete.grid(row=3, column=0, padx=10, pady=10)

    btn_clear = tk.Button(menu_frame, text="حذف کامل جداول آردوینو", command=clear_arduino, bg="#FF80AB", fg="white", font=('Arial', 12, 'bold'), relief="ridge", width=20, height=2)
    btn_clear.grid(row=4, column=0, padx=10, pady=10)

    btn_exit = tk.Button(menu_frame, text="خروج", command=window.destroy, bg="#FF80AB", fg="white", font=('Arial', 12, 'bold'), relief="ridge", width=20, height=2)
    btn_exit.grid(row=5, column=0, padx=10, pady=10)

    # اجرای برنامه
    window.mainloop()

def get_log(x):  # 4 -> 2
    ans = 0
    while (x > 1):
        x //= 2
        ans += 1
    return ans

def define_curcuit_input():
    input_name = input("enter the curcuit input: ")
    if (len(input_name) != 3):
        print("please enter a valid curcuit input")
        return
    if ((input_name[:2] != "in") | 
        ((input_name[2] < '0') | (input_name[2] > '7'))):
        print("please enter a valid curcuit input")
        return
    input_value = input("enter the value: ")
    if ((input_value != "1") & (input_value != "0")):
        print("please enter a valid value")
        return
    xxx = 0
    if (input_value == "1"):
        xxx = 1
    circuit_inputs[input_name] = xxx
    return

def add_curcuit_variables():
    for key in tables:
        df = tables[key]
        for name in df.columns:
            if ((name not in ciruit_variables) &
                (name not in circuit_inputs)):
                ciruit_variables[name] = -1
    return

def calculate_curcuit_variable(var):
    if (var in circuit_inputs):
        return circuit_inputs[var]
    if (ciruit_variables[var] != -1):
        return ciruit_variables[var]
    good_table = None
    for key in tables:
        df = tables[key]
        rows = get_log(df.shape[0])
        if (var in df.columns[rows:]):
            good_table = df
            break
    if good_table is None:
        return -1
    rows = get_log(good_table.shape[0])
    ind = 0
    for i in range(0, rows):
        ind *= 2
        xxx = calculate_curcuit_variable(good_table.columns[i])
        if (xxx == -1):
            return -1
        ind += xxx
    outs = good_table.columns[rows:]
    return good_table.values[ind][rows + outs.get_loc(var)]

def process_curcuit():
    ciruit_variables.clear()
    add_curcuit_variables()
    for var in ciruit_variables:
        ciruit_variables[var] = calculate_curcuit_variable(var)
    print("----------")
    for input in circuit_inputs:
        if (circuit_inputs[input] != -1):
            print(input + ": " + str(circuit_inputs[input]))
    print("----------")
    for out in ciruit_variables:
        if (ciruit_variables[out] != -1):
            print(out + ": " + str(ciruit_variables[out]))
    return

def terminal_input():
    while True:
        user_input = input("enter the command please: ")
        if ((user_input != "process") & (user_input != "define")):
            print("try again!")
            continue
        if (user_input == "define"):
            define_curcuit_input()
            continue
        if (user_input == "process"):
            process_curcuit()
            continue


if __name__ == "__main__":
    terminal_thread = threading.Thread(target=terminal_input)
    gui_thread = threading.Thread(target=create_gui)
    
    terminal_thread.start()
    gui_thread.start()

    terminal_thread.join()
    gui_thread.join()
