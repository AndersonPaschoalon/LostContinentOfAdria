import os
import traceback
import sys
from PIL import Image
from os import listdir, path

APP_VERSION = "v0.1.0"
APP_NAME = "jpg-to-bmp.py"
APP_LICENSE = "MIT"
APP_AUTHOR = "Anderson Paschoalon"
APP_CONTACT = "anderson.paschoalon@gmail.com"


def help_menu():
    print("jpg-to-bmp.py")
    print("    Converts the files on ./jpg from JPEG to BMP format, saving them in the ./bmp directory")
    print("")
    print("Usage:")
    print("    ./jpg-to-bmp.py [-h|--help|-v|--version]")
    print("Options:")
    print("    -h|--help: Prints this help menu")
    print("    -v|--version: Prints the version")


def version_menu():
    print(APP_NAME, " -- ", APP_VERSION)
    print("Licence : ", APP_LICENSE)
    print("Author  : ", APP_AUTHOR)
    print("Contact : ", APP_CONTACT)


def batch_img_conversion(dir_name: str, src_ext: list, dst_dir: str, dst_ext: str):
    if os.path.isdir(dir_name) and os.path.isdir(dst_dir):
        for file in listdir(dir_name):
            file_name, file_type = path.splitext(file)
            try:
                if file_type in src_ext:
                    file_path = os.path.join(dir_name, file_name + file_type)
                    file_path_dst = os.path.join(dst_dir, file_name + dst_ext)
                    im = Image.open(file_path)
                    print(file_name + file_type, " -> ", file_name + dst_ext)
                    im.save(file_path_dst)
            except (IOError, OSError):
                traceback.print_exc()
                print('** Error: {} Conversion'.format(file))

    else:
        print("** Error: soruce directory <", dir_name + "> or destination directory <", dst_dir, "> does not exist!")


def main(argv):
    try:
        if len(argv) > 1:
            if argv[1] == "-h" or argv[1] == "--help":
                help_menu()
            elif argv[1] == "-v" or argv[1] == "--version":
                version_menu()
            else:
                batch_img_conversion('jpg', ['.jpg', '.jpeg'], 'bmp', '.bmp')
        else:
            batch_img_conversion('jpg', ['.jpg', '.jpeg'], 'bmp', '.bmp')
    except:
        traceback.print_exc()
        print("** Error: exception caught!")
        sys.exit(2)


if __name__ == '__main__':
    main(sys.argv)
