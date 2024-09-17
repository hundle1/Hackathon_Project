import hashlib
import os


def hash_folder(folder_path):
    BUF_SIZE = 65536
    folder_hash = hashlib.sha256()

    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        if os.path.isfile(file_path):
            with open(file_path, 'rb') as file:
                while True:
                    data = file.read(BUF_SIZE)
                    if not data:
                        break
                    folder_hash.update(data)

    return folder_hash.hexdigest()


folder_path = input("Nhập đường dẫn thư mục: ")

folder_hash = hash_folder(folder_path)

folder_name = os.path.basename(folder_path)

output_filename = f"{folder_name}.txt"

print(f"Đã sử dụng SHA-256 để hash thư mục {folder_path} thành công.")
print(f"Mã hash của thư mục: {folder_hash}")

with open(os.path.join(folder_path, output_filename), 'w') as file:
    file.write(folder_hash)
    print(f"Mã hash đã được lưu vào: {os.path.join(folder_path, output_filename)}")
