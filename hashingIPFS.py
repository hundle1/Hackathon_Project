import hashlib
import os
import ipfshttpclient

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


def upload_to_ipfs(folder_path, ipfs_node="http://127.0.0.1:8081", ipfs_port="5001"):

    api = ipfshttpclient.connect(ipfs_node, ipfs_port)
    folder_hash = hash_folder(folder_path)

    folder_cid = api.add(folder_path)

    return folder_cid


if __name__ == "__main__":
    folder_path = input("Nhập đường dẫn thư mục: ")
    folder_hash = hash_folder(folder_path)
    ipfs_hash = upload_to_ipfs(folder_path)

    print(f"Đã sử dụng SHA-256 để hash thư mục {folder_path} thành công.")
    print(f"Mã hash của thư mục: {folder_hash}")
    print(f"Đã tải thư mục lên IPFS thành công.")
    print(f"Mã hash IPFS của thư mục: {ipfs_hash}")
